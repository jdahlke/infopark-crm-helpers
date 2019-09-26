# frozen_string_literal: true

module CrmHelper
  include RSpec::Mocks::ExampleMethods

  def setup_crm
    Crm.configure do |config|
      config.tenant  = ENV['WEBCRM_TENANT'] || crm_configuration[:tenant]
      config.login   = ENV['WEBCRM_LOGIN'] || crm_configuration[:login]
      config.api_key = ENV['WEBCRM_API_KEY'] || crm_configuration[:api_key]
    end
  end

  def stub_crm_request(method, resource, options = {})
    return if ENV['WEBCRM_INTEGRATION'].present?

    tenant = crm_configuration[:tenant]
    url = %r{\Ahttps://.*:.*@#{tenant}.crm.infopark.net/api2/#{resource}\z}
    body_path = File.expand_path("crm/fakeweb/api2/#{resource}.json", __dir__)
    return unless File.exist?(body_path)

    body = File.read(body_path)
    options.reverse_merge!(body: body)

    FakeWeb.register_uri(method, url, options)
  end

  protected

  def crm_configuration
    return @crm_configuration if defined?(@crm_configuration)

    crm_config_path = File.expand_path('../config/crm.yml', __dir__)
    config = YAML.load_file(crm_config_path)['test']
    @crm_configuration = config.with_indifferent_access
  rescue StandardError
    @crm_configuration = HashWithIndifferentAccess.new
  end
end
