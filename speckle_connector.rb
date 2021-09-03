require "sketchup"

require "extensions"

module SpeckleSystems
  module SpeckleConnector

    file = __FILE__.dup
    # Account for Ruby encoding bug under Windows.
    file.force_encoding('UTF-8') if file.respond_to?(:force_encoding)
    # Support folder should be named the same as the root .rb file.
    folder_name = ::File.basename(file, '.*')

    # Path to the root .rb file (this file).
    PATH_ROOT = ::File.dirname(file).freeze

    # Path to the support folder.
    PATH = ::File.join(PATH_ROOT, folder_name).freeze

    unless file_loaded?(__FILE__)

      ex = SketchupExtension.new(
        "Hello Cube",
        "C:/Users/izzy lyseggen/Documents/dev/next/sketchup_connector/speckle_connector/main"
      )

      ex.description = "Speckle Connector for SketchUp"

      ex.version     = "0.0.1"

      ex.copyright   = "AEC Systems Ltd."

      ex.creator     = "Speckle Systems"

      Sketchup.register_extension(ex, true)

      file_loaded(__FILE__)

    end
  end
end
