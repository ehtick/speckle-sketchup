# frozen_string_literal: true

require_relative 'bindings/binding'
require_relative '../ui/dialog'
require_relative '../constants/path_constants'

require_relative '../commands/send_selection'
require_relative '../commands/receive_objects'
require_relative '../commands/action_command'
require_relative '../commands/save_stream'
require_relative '../commands/remove_stream'
require_relative '../commands/notify_connected'
require_relative '../commands/user_preferences_updated'
require_relative '../commands/model_preferences_updated'
require_relative '../commands/activate_diffing'
require_relative '../commands/apply_mappings'
require_relative '../commands/clear_mappings'
require_relative '../commands/mapper_source_updated'

require_relative '../actions/mapper_initialized'
require_relative '../actions/reload_accounts'
require_relative '../actions/load_saved_streams'
require_relative '../actions/init_local_accounts'
require_relative '../actions/collect_preferences'
require_relative '../actions/deactivate_diffing'
require_relative '../actions/collect_versions'
require_relative '../actions/mapped_entities_updated'
require_relative '../actions/clear_mappings_from_table'
require_relative '../actions/isolate_mappings_from_table'
require_relative '../actions/hide_mappings_from_table'
require_relative '../actions/select_mappings_from_table'
require_relative '../actions/show_all_entities'
require_relative '../actions/clear_mapper_source'

module SpeckleConnector3
  module Ui
    SPECKLE_LEGACY_BINDING_NAME = 'speckle_legacy_binding'
    VUE_UI_HTML = Pathname.new(File.join(SPECKLE_SRC_PATH, '..', 'vue_ui', 'index.html')).cleanpath.to_s

    # View that provided by vue.js
    class LegacyBinding < Binding
      # rubocop:disable Metrics/MethodLength
      def commands
        @commands ||= {
          send_selection: Commands::SendSelection.new(@app, self),
          receive_objects: Commands::ReceiveObjects.new(@app, self),
          reload_accounts: Commands::ActionCommand.new(@app, self, Actions::ReloadAccounts),
          init_local_accounts: Commands::ActionCommand.new(@app, self, Actions::InitLocalAccounts),
          load_saved_streams: Commands::ActionCommand.new(@app, self, Actions::LoadSavedStreams),
          save_stream: Commands::SaveStream.new(@app, self ),
          remove_stream: Commands::RemoveStream.new(@app, self),
          notify_connected: Commands::NotifyConnected.new(@app, self),
          collect_preferences: Commands::ActionCommand.new(@app, self, Actions::CollectPreferences),
          collect_versions: Commands::ActionCommand.new(@app, self, Actions::CollectVersions),
          user_preferences_updated: Commands::UserPreferencesUpdated.new(@app, self),
          model_preferences_updated: Commands::ModelPreferencesUpdated.new(@app, self),
          activate_diffing: Commands::ActivateDiffing.new(@app, self),
          deactivate_diffing: Commands::ActionCommand.new(@app, self, Actions::DeactivateDiffing),
          collect_mapped_entities: Commands::ActionCommand.new(@app, self, Actions::MappedEntitiesUpdated),
          apply_mappings: Commands::ApplyMappings.new(@app, self),
          clear_mappings: Commands::ClearMappings.new(@app, self,),
          clear_mappings_from_table: Commands::ActionCommand.new(@app, self, Actions::ClearMappingsFromTable),
          isolate_mappings_from_table: Commands::ActionCommand.new(@app, self, Actions::IsolateMappingsFromTable),
          hide_mappings_from_table: Commands::ActionCommand.new(@app, self,Actions::HideMappingsFromTable),
          select_mappings_from_table: Commands::ActionCommand.new(@app, self, Actions::SelectMappingsFromTable),
          show_all_entities: Commands::ActionCommand.new(@app, self, Actions::ShowAllEntities),
          mapper_source_updated: Commands::MapperSourceUpdated.new(@app, self),
          clear_mapper_source: Commands::ActionCommand.new(@app, self, Actions::ClearMapperSource),
          mapper_initialized: Commands::ActionCommand.new(@app, self, Actions::MapperInitialized)
        }.freeze
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
