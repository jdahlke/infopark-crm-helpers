module CrmHelper
  include RSpec::Mocks::ExampleMethods

  def setup_crm
    Crm.configure do |config|
      config.tenant  = ENV['WEBCRM_TENANT'] || crm_configuration[:tenant]
      config.login   = ENV['WEBCRM_LOGIN'] || crm_configuration[:login]
      config.api_key = ENV['WEBCRM_API_KEY'] || crm_configuration[:api_key]
    end
  end

  def stub_crm_type(method, type, options = {})
    return if ENV['WEBCRM_INTEGRATION'].present?

    url = %r{https://.*:.*@#{crm_configuration[:tenant]}.crm.infopark.net/api2/types/#{type}}
    path_to_body_file = File.expand_path(File.join(%W(.. crm fakeweb api2 types #{type}.json)), __FILE__)
    body = File.read(path_to_body_file)
    options.reverse_merge!(body: body)

    FakeWeb.register_uri(method, url, options)
  end

  protected

  def crm_configuration
    @crm_configuration ||= begin
      crm_config_path = File.expand_path('../../../.crm.yml', __FILE__)
      YAML.load_file(crm_config_path).with_indifferent_access
    rescue
      {}
    end
  end
end
