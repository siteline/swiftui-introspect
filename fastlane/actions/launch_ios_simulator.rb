module Fastlane
  module Actions
    module SharedValues
      IOS_SIMULATOR_CUSTOM_VALUE = :IOS_SIMULATOR_CUSTOM_VALUE
    end

    class LaunchIosSimulatorAction < Action
      @@already_booted_code = 164

      def self.run(params)
        devices = params[:devices] || Array(params[:device])
        available_sims = FastlaneCore::Simulator.all

        devices.each do |device|
          sim = available_sims.detect { |d| device == "#{d.name} (#{d.os_version})" }
          if sim.nil?
            UI.error "Device not found: #{device}"
            next
          end

          if params[:reset_before_launching]
            sim.reset
          end

          `xcrun simctl boot #{sim.udid} > /dev/null 2>&1`
          if $?.exitstatus == @@already_booted_code
            UI.important "Skipping #{device} (already booted)"
          end

          UI.message "Booted #{device} [#{sim.udid}]" unless $?.exitstatus == @@already_booted_code
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Launch iOS simulators beforehand to allow for boot time"
      end

      def self.details
        "Run `xcrun instruments -s` for the list of available simulators"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :device,
                                       env_name: "SCAN_DEVICE",
                                       description: "The name of the simulator type you want to run tests on (e.g. 'iPhone 6 (10.0)')", # a short description of this parameter
                                       conflicting_options: [:devices],
                                     ),
          FastlaneCore::ConfigItem.new(key: :devices,
                                       env_name: "SCAN_DEVICES",
                                       description: "Array of devices to run the tests on (e.g. ['iPhone 6 (10.0)', 'iPad Air (8.3)'])",
                                       is_string: false,
                                       conflicting_options: [:device],
                                       optional: true,
                                     ),
          FastlaneCore::ConfigItem.new(key: :reset_before_launching,
                                       env_name: "FL_IOS_SIMULATOR_RESET",
                                       description: "Should reset simulators before launching",
                                       is_string: false,
                                       default_value: false,
                                     ),
        ]
      end

      def self.author
        "Flávio Caetano (@fjcaetano)"
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
