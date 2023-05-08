# frozen_string_literal: true

require_relative 'collection'
require_relative 'layer_collection'
require_relative '../../../built_elements/view3d'
require_relative '../../../built_elements/revit/direct_shape'

module SpeckleConnector
  module SpeckleObjects
    module Speckle
      module Core
        module Models
          # ModelCollection object that collect other speckle objects under it's elements.
          class ModelCollection < Collection
            DIRECT_SHAPE = SpeckleObjects::BuiltElements::Revit::DirectShape
            VIEW3D = SpeckleObjects::BuiltElements::View3d
            def initialize(name:, active_layer:, elements: [], application_id: nil)
              super(
                name: name,
                collection_type: 'sketchup model',
                elements: elements,
                application_id: application_id
              )
              self[:active_layer] = active_layer
            end

            def self.from_sketchup_model(sketchup_model, speckle_state, units, preferences, &convert)
              model_collection = ModelCollection.new(
                name: 'Sketchup Model', active_layer: sketchup_model.active_layer.display_name,
                application_id: sketchup_model.guid
              )

              # Direct shapes will pass directly to elements which are already flattened with all children
              model_collection[:elements] += collect_direct_shapes(sketchup_model, units, preferences)

              # Views will pass directly to elements since they don't have any relation with layers and geometries.
              model_collection[:elements] += VIEW3D.from_model(sketchup_model, units) if sketchup_model.pages.any?

              # Add layer collections.
              model_collection[:elements] += LayerCollection.create_layer_collections(sketchup_model)

              sketchup_model.selection.each do |entity|
                layer_collection = LayerCollection.get_or_create_layer_collection(entity.layer, model_collection)
                new_speckle_state, converted_object_with_entity = convert.call(entity, preferences, speckle_state)
                speckle_state = new_speckle_state
                unless converted_object_with_entity.nil?
                  layer_collection[:elements] = [] if layer_collection[:elements].nil?
                  layer_collection[:elements].append(converted_object_with_entity)
                end
              end

              return speckle_state, model_collection
            end

            def self.collect_direct_shapes(sketchup_model, units, preferences)
              DIRECT_SHAPE.direct_shapes_on_selection(sketchup_model).collect do |entities|
                entity = entities[0]
                path = entities[1..-1]

                direct_shape = DIRECT_SHAPE.from_entity(entity, path, units, preferences)
                [direct_shape, [entity]]
              end
            end
          end
        end
      end
    end
  end
end