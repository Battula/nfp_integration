class Rails::Application::Configuration < Rails::Engine::Configuration
  def nfp_integration
    @nfp_configuration ||= ::NfpIntegration.configuration
  end
end

module NfpIntegration
  module Railties
    class Railtie < Rails::Railtie

      initializer "railtie.nfp_soap_security" do |app|

        NfpIntegration.configure do |config|
          config.url = app.config.nfp_integration.url
          config.user_id = app.config.nfp_integration.user_id
          config.password = app.config.nfp_integration.password
        end

      end


    end
  end
end
