require 'spec_helper'

describe Crm::Helpers do
  it 'has a version number' do
    expect(Crm::Helpers::VERSION).not_to be nil
  end

  it 'can be included without errors' do
    expect { subject }.to_not raise_error
  end
end
