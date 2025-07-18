module Fastlane
  module Actions
    module SharedValues
      ANDROID_VERSION_NAME = :ANDROID_VERSION_NAME
    end

    class AndroidGetVersionNameAction < Action
      def self.run(params)
        gradle_file_path = Helper::VersioningAndroidHelper.get_gradle_file_path(params[:gradle_file])
        version_name_key = params[:version_name_key]
        version_name = Helper::VersioningAndroidHelper.read_key_from_gradle_file(gradle_file_path, version_name_key)

        if version_name == false
          UI.user_error!("Unable to find the #{version_name_key} in build.gradle file at #{gradle_file_path}.")
        end

        UI.success("👍  Current Android Version Name(#{version_name_key}) is: #{version_name}")

        # Store the Version Name in the shared hash
        Actions.lane_context[SharedValues::ANDROID_VERSION_NAME] = version_name
      end

      def self.description
        "Get the Version Name of your Android project"
      end

      def self.details
        "This action will return current Version Name of your Android project."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :gradle_file,
                                  env_name: "FL_ANDROID_GET_VERSION_NAME_GRADLE_FILE",
                               description: "(optional) Specify the path to your app build.gradle if it isn't in the default location",
                                  optional: true,
                                      type: String,
                             default_value: "app/build.gradle",
                              verify_block: proc do |value|
                                UI.user_error!("Could not find app build.gradle file") unless File.exist?(value) || Helper.test?
                              end),
          FastlaneCore::ConfigItem.new(key: :version_name_key,
                                  env_name: "FL_ANDROID_GET_VERSION_NAME_VERSION_NAME_KEY",
                               description: "(optional) Set specific Version Name Key",
                                  optional: true,
                                      type: String,
                             default_value: "versionName")
        ]
      end

      def self.output
        [
          ['ANDROID_VERSION_NAME', 'The Version Name of your Android project']
        ]
      end

      def self.return_value
        "The Version Name of your Android project"
      end

      def self.authors
        ["Igor Lamoš"]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end

      def self.example_code
        [
          'version_name = android_get_version_name # build.gradle is in the default location',
          'version_name = android_get_version_name(gradle_file: "/path/to/build.gradle")'
        ]
      end
    end
  end
end
