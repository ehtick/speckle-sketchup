# frozen_string_literal: true

require_relative 'dictionary_handler'
require_relative '../../constants/dict_constants'
require_relative '../../constants/type_constants'

module SpeckleConnector
  module SketchupModel
    module Dictionary
      # Dictionary handler of the speckle entity.
      class SpeckleEntityDictionaryHandler < DictionaryHandler
        # Writes initial data while speckle entity is creating first time.
        # @param sketchup_entity [Sketchup::Entity] Sketchup entity to write data into it's attribute dictionary.
        def self.write_initial_base_data(sketchup_entity)
          initial_dict_data = {
            # Add here more if you want to write here initial data
            SPECKLE_ID => '',
            SPECKLE_TYPE => BASE_OBJECT,
            APPLICATION_ID => '',
            TOTAL_CHILDREN_COUNT => 0
          }
          set_hash(sketchup_entity, initial_dict_data)
        end
      end
    end
  end
end