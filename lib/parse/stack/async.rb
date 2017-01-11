require 'sucker_punch'
require 'active_support'
require 'active_support/core_ext'
require 'parse/stack'
require "parse/stack/async/version"

# This module is defined in the Parse-Stack gem.
# @see {Parse::Stack}
module Parse
  # This module is defined in the Parse-Stack gem.
  # @see {Parse::Stack}
  module Stack
    # This is a plugin to Parse Stack that allows objects to be saved and deleted in a
    # background thread, while providing you a callback block.
    module Async

      # A class to support running blocks in serial queue on a background thread.
      # @!visibility private
      class SerialDispatchQueue
        include SuckerPunch::Job
        workers 1 # serial queue
        # @!visibility private
        def perform(block = nil)
          block.call() if block.respond_to?(:call)
          block = nil # help gc
        end
      end # Serial

      # A class to support running blocks in concurrent queue on a background thread.
      # @!visibility private
      class ParallelDispatchQueue
        include SuckerPunch::Job
        # @!visibility private
        def perform(block = nil)
          block.call() if block.respond_to?(:call)
          block = nil # help gc
        end
      end # Parallel

      # Helper method to run a block on a background thread.
      # @param type [Symbol] the queue to use when dispatching the block.
      #   * :serial - add the request to a serial queue.
      #   * :parallel - add the request to a concurrent queue.
      def self.run(type = :parallel)
        raise "You need to pass a block to async." unless block_given?
        if type == :parallel
          ParallelDispatchQueue.perform_async Proc.new
        else
          SerialDispatchQueue.perform_async Proc.new
        end
      end

    end # Async
  end # Stack

  # Additions to the Parse::Object class.
  class Object < Pointer
    # Adds support for saving a Parse object in the background.
    # @example
    #  object.save_eventually do |success|
    #     puts "Saved successfully" if success
    #  end
    # @yield A block to call after the save has completed.
    # @yieldparam [Boolean] success whether the save was successful.
    # @return [Boolean] whether the job was enqueued.
    def save_eventually
      block = block_given? ? Proc.new : nil
      _self = self
      Parse::Stack::Async.run do
        begin
          result = true
          _self.save!
        rescue => e
          result = false
          puts "[SaveEventually] Failed for object #{_self.parse_class}##{_self.id}: #{e}"
        ensure
          block.call(result) if block
          block = nil
          _self = nil
        end # begin
      end # do
    end # save_eventually

    # Adds support for deleting a Parse object in the background.
    # @example
    #  object.destroy_eventually do |success|
    #     puts 'Deleted successfully' if success
    #  end
    # @yield A block to call after the deletion has completed.
    # @yieldparam [Boolean] success whether the save was successful.'
    # @return [Boolean] whether the job was enqueued.
    def destroy_eventually
      block = block_given? ? Proc.new : nil
      _self = self
      Parse::Stack::Async.run do
        begin
          result = true
          _self.destroy
        rescue => e
          result = false
          puts "[DestroyEventually] Failed for object #{_self.parse_class}##{_self.id}: #{e}"
        ensure
          block.call(result) if block
          block = nil
          _self = nil
        end # begin
      end # do
    end # destroy_eventually
    alias_method :delete_eventually, :destroy_eventually

  end # Object

end # Parse
