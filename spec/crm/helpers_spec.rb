require 'spec_helper'

describe Crm::Helpers do
  subject do
    Class.new do
      include Crm::Helpers
    end
  end

  it 'has a version number' do
    expect(Crm::Helpers::VERSION).not_to be nil
  end

  it 'can be included without errors' do
    expect { subject }.to_not raise_error
  end

  it 'have Crm::Helpers::Attributes as an ancestor' do
    expect(subject.ancestors).to include(Crm::Helpers::Attributes)
  end

  it 'have Crm::Helpers::Validations as an ancestor' do
    expect(subject.ancestors).to include(Crm::Helpers::Validations)
  end
end
