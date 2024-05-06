# frozen_string_literal: true

require_relative 'card'

module SpeckleConnector
  module Cards
    # Receive result that attached to the receiver card.
    class ReceiveResult < Hash
      # @return [Boolean] whether display them or not.
      attr_reader :display

      # @return [Array<Integer>] object ids that baked after receive.
      attr_reader :baked_object_ids

      # @param baked_object_ids [Array<Integer>]  object ids that baked after receive.
      def initialize(baked_object_ids, display)
        super()
        @baked_object_ids = baked_object_ids
        @display = display
        self[:bakedObjectIds] = baked_object_ids
        self[:display] = display
      end
    end
  end
end
