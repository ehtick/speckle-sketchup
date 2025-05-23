# frozen_string_literal: true

require_relative 'collection'
require_relative '../../../../sketchup_model/query/layer'
require_relative '../../../../constants/type_constants'
require_relative '../../../other/color'
require_relative '../../../other/display_style'

module SpeckleConnector3
  module SpeckleObjects
    module Speckle
      module Core
        module Models
          # LayerCollection object that collect other speckle objects under it's elements.
          class LayerCollection < Collection
            SPECKLE_TYPE = SPECKLE_CORE_MODELS_LAYER_COLLECTION
            BASE_DICT = SketchupModel::Dictionary::SpeckleEntityDictionaryHandler
            # rubocop:disable Metrics/ParameterLists
            def initialize(name:, visible:, is_folder:, display_style: nil, color: nil, elements: [],
                           application_id: nil)
              super(
                name: name,
                collection_type: 'layer',
                elements: elements,
                application_id: application_id
              )
              self[:speckle_type] = SPECKLE_TYPE
              self[:visible] = visible
              self[:is_folder] =  is_folder
              self[:color] = color unless color.nil?
              self[:displayStyle] = display_style unless display_style.nil?
            end
            # rubocop:enable Metrics/ParameterLists

            def self.create_layer_collections(sketchup_model)
              headless_layers = sketchup_model.layers.layers.collect do |layer|
                from_layer(layer)
              end

              folders = sketchup_model.layers.folders.collect do |folder|
                from_folder(folder)
              end

              headless_layers + folders
            end

            # @param folder [Sketchup::LayerFolder] sketchup layer folder that might contains other folders and layers.
            def self.from_folder(folder)
              layers = folder.layers.collect { |layer| from_layer(layer) }
              sub_folders = folder.folders.collect { |sub_folder| from_folder(sub_folder) }
              LayerCollection.new(
                name: folder.display_name,
                visible: folder.visible?,
                is_folder: true,
                elements: layers + sub_folders,
                application_id: folder.persistent_id.to_s
              )
            end

            # @param layer [Sketchup::Layer] sketchup layer (tag) that objects can be assigned..
            def self.from_layer(layer)
              LayerCollection.new(
                name: layer.display_name,
                visible: layer.visible?,
                is_folder: false,
                display_style: Other::DisplayStyle.from_layer(layer),
                application_id: layer.persistent_id.to_s
              )
            end

            # @param entity_layer [Sketchup::Layer] entity layer.
            # @param collection [Array] collection to search elements for entity's layer.
            # rubocop:disable Metrics/CyclomaticComplexity
            def self.get_or_create_layer_collection(entity_layer, collection)
              folder_path = SpeckleConnector3::SketchupModel::Query::Layer.path(entity_layer)
              entity_layer_path = folder_path + [entity_layer]
              entity_layer_path.each do |folder|
                coll = collection['@elements'] || collection['elements']
                collection_candidate = coll.find do |el|
                  next if el.is_a?(Array)

                  el[:speckle_type] == SPECKLE_TYPE && el[:collectionType] == 'layer' &&
                    el[:name] == folder.display_name
                end
                if collection_candidate.nil?
                  # color = folder.respond_to?(:color) ? SpeckleObjects::Other::Color.to_int(folder.color) : nil
                  collection_candidate = LayerCollection.new(
                    name: folder.display_name, visible: folder.visible?,
                    is_folder: folder.is_a?(Sketchup::LayerFolder), color: nil, application_id: folder.persistent_id.to_s
                  )
                  # Before switching collection with the new one, we should add it to current collection's elements
                  coll.append(collection_candidate)
                end
                collection = collection_candidate
              end

              collection
            end
            # rubocop:enable Metrics/CyclomaticComplexity

            # @param state [States::State] state of the Speckle application.
            def self.to_native(state, layer_collection, layer_or_folder, entities, &convert_to_native)
              sketchup_model = state.sketchup_state.sketchup_model
              elements = layer_collection['@elements'] || layer_collection['elements']
              # name = layer_collection['name']
              # name = layer_collection['full_path'] if layer_collection['full_path']
              # name = SketchupModel::Query::Layer.get_last_increment_layer(sketchup_model, name)

              # NOTE: this is a v3 way of finding layers since we have incremented layer numberings
              layer = sketchup_model.layers.find do |l|
                BASE_DICT.get_attribute(l, :speckle_id) == layer_collection['id']
              end

              # layer = sketchup_model.layers.find { |l| l.display_name == name }
              layer_or_folder = layer if layer

              elements.each do |element|
                # NOTE: this is where we switch the target layer for conversions.
                new_state, _converted_entities = convert_to_native.call(state, element, layer_or_folder, entities)
                state = new_state
              end

              return state, []
            end
          end
        end
      end
    end
  end
end
