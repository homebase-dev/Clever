require 'rails-settings-ui'

#= Application-specific
#
# # You can specify a controller for RailsSettingsUi::ApplicationController to inherit from:
# RailsSettingsUi.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
#
# # Render RailsSettingsUi inside a custom layout (set to 'application' to use app layout, default is RailsSettingsUi's own layout)
# RailsSettingsUi::ApplicationController.layout 'admin'

RailsSettingsUi.setup do |config|
  #config.ignored_settings = [:company_name] # Settings not displayed in the interface
  config.settings_class = "Settings" # Customize settings class name
end

Rails.application.config.to_prepare do
  # If you use a *custom layout*, make route helpers available to RailsSettingsUi:
  # RailsSettingsUi.inline_main_app_routes!
end


# Make settings only available to admin users
Rails.application.config.to_prepare do
  RailsSettingsUi::ApplicationController.module_eval do
    before_filter :check_settings_permissions

    private
    def check_settings_permissions
      render status: 403 unless current_user && current_user.admin?
    end
  end
end 