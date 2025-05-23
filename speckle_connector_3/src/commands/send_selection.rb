# frozen_string_literal: true

require_relative 'command'
require_relative '../actions/send_selection'

module SpeckleConnector3
  module Commands
    # Command to send selection to Speckle Server.
    class SendSelection < Command
      def _run(_resolve_id, data)
        stream_id = data['stream_id']
        action = Actions::SendSelection.new(stream_id)
        app.update_state!(action)
      end
    end
  end
end
