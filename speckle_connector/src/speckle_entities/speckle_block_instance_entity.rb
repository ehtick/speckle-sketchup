# frozen_string_literal: true

require_relative 'speckle_entity'
require_relative '../immutable/immutable'

module SpeckleConnector
  module SpeckleEntities
    # Speckle block instance entity is the state object for Sketchup::Entity and it's converted (or not yet) state.
    class SpeckleBlockInstanceEntity < SpeckleEntities::SpeckleEntity
      include Immutable::ImmutableUtils

      # @return [Hash{String=>SpeckleObjects::Base}] speckle objects belongs to block instance
      attr_reader :children

      # @return [Boolean] whether block instance represented as sketchup group or component instance
      attr_reader :is_sketchup_group

      def initialize(sketchup_group_or_component_instance, traversed_speckle_object, stream_id)
        @children = traversed_speckle_object[:__closure].nil? ? {} : traversed_speckle_object[:__closure]
        @is_sketchup_group = traversed_speckle_object[:is_sketchup_group]
        super(sketchup_group_or_component_instance, traversed_speckle_object, children, stream_id)
      end

      alias sketchup_edge sketchup_entity
    end
  end
end