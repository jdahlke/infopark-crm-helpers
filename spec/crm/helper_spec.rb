require 'spec_helper'

describe Crm::Helper do
  subject do
    Class.new do
      include Crm::Helper
    end
  end

  it 'have Crm::Helpers::Attributes as an ancestor' do
    expect(subject.ancestors).to include(Crm::Helpers::Attributes)
  end
end
