# frozen_string_literal: true

require 'spec_helper'

describe Crm::Helper do
  subject do
    Class.new do
      include Crm::Helper
    end
  end

  %i[Attributes Finders Persistence].each do |module_name|
    it "has Crm::Helpers::#{module_name} as an ancestor" do
      full_name = "Crm::Helpers::#{module_name}"
      expect(subject.ancestors).to include(full_name.constantize)
    end
  end
end
