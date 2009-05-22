require 'rubygems'
gem 'rails', '= 2.3.2'
require 'initializer' # This is the rails-2.3.2/lib/initializer

module BriskBills

  class Configuration < Rails::Configuration
    attr_accessor :view_paths

    def initialize
      self.view_paths = []
      super
    end

    private
      def framework_root_path
        BRISKBILLS_ROOT + '/vendor/rails'
      end

      # Provide the load paths for the BriskBills installation
      def default_load_paths
        paths = ["#{BRISKBILLS_ROOT}/test/mocks/#{environment}"]

        # Add the app's controller directory
        paths.concat(Dir["#{BRISKBILLS_ROOT}/app/controllers/"])

        # Add the app's model_views directory
        paths.concat(Dir["#{BRISKBILLS_ROOT}/app/model_views/"])

        # Followed by the standard includes.
        paths.concat %w(
          app
          app/models
          app/controllers
          app/helpers
          config
          lib
          vendor
        ).map { |dir| "#{BRISKBILLS_ROOT}/#{dir}" }.select { |dir| File.directory?(dir) }

        paths.concat builtin_directories
      end

      def default_plugin_paths
        [
          "#{RAILS_ROOT}/vendor/plugins",
          "#{BRISKBILLS_ROOT}/vendor/plugins"
        ]
      end

      def default_view_path
        File.join(BRISKBILLS_ROOT, 'app', 'views')
      end

      def default_controller_paths
        [File.join(BRISKBILLS_ROOT, 'app', 'controllers')]
      end
  end

  class Initializer < Rails::Initializer
    def self.run(command = :process, configuration = Configuration.new)
      Rails.configuration = configuration
      super
    end

    def initialize_framework_views
      view_paths = returning [] do |arr|
        # Add the singular view path if it's not in the list
        arr << configuration.view_path if !configuration.view_paths.include?(configuration.view_path)
        # Add the default view paths
        arr.concat configuration.view_paths
      end
      if configuration.frameworks.include?(:action_controller) || defined?(ActionController::Base)
        view_paths.each do |vp|
          unless ActionController::Base.view_paths.include?(vp)
            ActionController::Base.prepend_view_path vp
          end
        end
      end
    end

    def admin
      configuration.admin
    end
  end

end
