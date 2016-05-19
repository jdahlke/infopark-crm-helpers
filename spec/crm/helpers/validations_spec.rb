require 'spec_helper'

describe Crm::Helpers::Validations do
  let(:crm_attributes) do
    {
      not_mandatory: { mandatory: false },
      not_mandatory_either: { mandatory: false },
      mandatory: { mandatory: true },
      amanda_tory: { mandatory: true }
    }.with_indifferent_access
  end

  let(:mandatory_attributes) do
    %i(amanda_tory mandatory)
  end

  subject do
    subject = Class.new do
      include Crm::Helpers::Validations

      represents_crm_type(:contact)
    end
    allow(subject).to receive(:crm_attributes).and_return(crm_attributes)
    subject
  end

  describe '.mandatory_crm_attributes' do
    it 'should return an array with mandatory attributes' do
      expect(subject.mandatory_crm_attributes).to eq(mandatory_attributes)
    end
  end

  describe 'represents_crm_type' do
    it 'should call .crm_attr_accessor with all mandatory attributes' do
      expect(subject).to receive(:crm_attr_accessor).with(*mandatory_attributes)
      subject.represents_crm_type(:contact)
    end
  end

  describe '.validates_crm_type' do
    it 'should validate the presence of all mandatory attributes' do
      expect(subject).to receive(:validates_presence_of).with(*mandatory_attributes)
      subject.validates_crm_type
    end

    it 'should validate our object with Crm::Helpers::Validator' do
      # This stub is relevant, because deep within, :validates_presence_of is just a
      # call to
      #
      #   validates_with ActiveModel::Validations::PresenceValidator
      #
      # That unfortunately breaks our expectation, if we let it go through. ;-(
      allow(subject).to receive(:validates_presence_of)

      expect(subject).to receive(:validates_with).with(Crm::Helpers::Validators::CrmAttributeValidator, anything)
      subject.validates_crm_type
    end
  end
end
