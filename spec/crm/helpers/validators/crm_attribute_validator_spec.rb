require 'spec_helper'

describe Crm::Helpers::Validators::CrmAttributeValidator, type: :validator do
  VALIDATORS = {
    boolean: Crm::Helpers::Validators::CrmBooleanValidator,
    datetime: Crm::Helpers::Validators::CrmDatetimeValidator,
    enum: Crm::Helpers::Validators::CrmEnumValidator,
    integer: Crm::Helpers::Validators::CrmIntegerValidator,
    list: Crm::Helpers::Validators::CrmListValidator,
    validator: Crm::Helpers::Validators::CrmMultienumValidator,
    string: Crm::Helpers::Validators::CrmStringValidator,
    text: Crm::Helpers::Validators::CrmTextValidator
  }.with_indifferent_access

  describe '#validate_each' do
    VALIDATORS.each_pair do |attribute_type, validator|
      let(:crm_attribute_type) { attribute_type }
      let(:crm_validator) { validator }
      let(:attribute_reader) { "#{crm_attribute_type}_attribute".to_sym }
      let(:value) { 'Any value here.' }

      let(:crm_attributes) do
        crm_attributes = {}.with_indifferent_access
        crm_attributes[attribute_reader] = {
          attribute_type: crm_attribute_type,
          mandatory: false
        }.with_indifferent_access
        crm_attributes
      end

      let(:class_with_validations) do
        class_with_validations = Class.new do
          include ActiveModel::Validations
          include Crm::Helpers::Attributes

          def self.name
            'ClassWithValidations'
          end
        end
        allow(class_with_validations).to receive(:crm_attributes).and_return(crm_attributes)
        class_with_validations.represents_crm_type :contact
        class_with_validations.crm_attr_reader attribute_reader
        all_attributes = *class_with_validations.crm_attr_readers
        class_with_validations.validates_with Crm::Helpers::Validators::CrmAttributeValidator,
                                              attributes: all_attributes
        class_with_validations
      end

      subject do
        class_with_validations.new
      end

      context "with a blank attribute of type #{attribute_type}" do
        it 'should not validate that attribute' do
          subject = class_with_validations.new

          allow(subject).to receive(attribute_reader).and_return(nil)
          expect(subject).to_not receive(:validates_with).with(crm_validator, anything)
          subject.valid?
        end
      end

      context "with a present attribute of type #{attribute_type}" do
        it "should validate with #{validator}" do
          subject = class_with_validations.new

          allow(subject).to receive(attribute_reader).and_return(value)
          expect(subject).to receive(:validates_with).with(crm_validator, anything)
          subject.valid?
        end
      end
    end
  end
end
