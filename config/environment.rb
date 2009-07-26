# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_tickets_session',
    :secret      => '52e23fb0fdb0bed8ec7ebca5060ddf0052272a98711654105a7f9ca794ff65403c76c7e760e8a8041ab9f6e0edca3fbd720adbd72033e8b092f560c0d6892ddc'
  }

  config.gem "haml"
end
