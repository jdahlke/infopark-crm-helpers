require 'spec_helper'

describe Crm::Helpers::Validators::CrmAttributeValidator, type: :validator do
  VALIDATORS = {
    boolean: {
      validator: ActiveModel::Validations::InclusionValidator,
      invalid_value: 'An invalid value',
      valid_value: true
    },
    datetime: {
      validator: Crm::Helpers::Validators::CrmDatetimeValidator,
      invalid_value: 'An invalid value',
      valid_value: DateTime.now
    },
    enum: {
      validator: ActiveModel::Validations::InclusionValidator,
      invalid_value: 4,
      valid_value: [2],
      valid_values: [2, 3, 5, 7]
    },
    integer: {
      validator: ActiveModel::Validations::NumericalityValidator,
      invalid_value: 'An invalid value',
      valid_value: 1
    },
    list: {
      validator:  Crm::Helpers::Validators::CrmListValidator,
      invalid_value: 1,
      valid_value: []
    },
    multienum: {
      validator: Crm::Helpers::Validators::CrmMultienumValidator,
      invalid_value: [2, 4],
      valid_value: [2, 3],
      valid_values: [2, 3, 5, 7]
    },
    string: {
      validator: ActiveModel::Validations::LengthValidator,
      invalid_value: 'This is a string that is way too long.',
      valid_value: 'A short string.',
      max_length: 16
    },
    text: {
      validator: ActiveModel::Validations::LengthValidator,
      invalid_value: 'This is a text that is way too long.',
      valid_value: 'A short string.',
      max_length: 16
    }
  }.with_indifferent_access

  describe '#validate' do
    VALIDATORS.each_pair do |attribute_type, data|
      let(:validator) { data[:validator] }
      let(:attribute_reader) { "#{attribute_type}_attribute".to_sym }
      let(:valid_value) { data[:valid_value] }
      let(:invalid_value) { data[:invalid_value] }

      let(:crm_attributes) do
        crm_attributes = {}.with_indifferent_access
        crm_attributes[attribute_reader] = {
          attribute_type: attribute_type,
          mandatory: false,
          max_length: data[:max_length],
          valid_values: data[:valid_values]
        }.with_indifferent_access
        crm_attributes
      end

      let(:class_with_validations) do
        class_with_validations = Class.new do
          include Crm::Helpers::Validations

          # This is required for ActiveModel::Validations.
          def self.name
            'ClassWithValidations'
          end
        end
        allow(class_with_validations).to receive(:crm_attributes).and_return(crm_attributes)
        class_with_validations.crm_attr_reader attribute_reader
        class_with_validations.validates_crm_type
        class_with_validations
      end

      subject do
        class_with_validations.new
      end

      context "when an attribute of type #{attribute_type} is blank" do
        it 'should not validate that attribute' do
          subject = class_with_validations.new

          allow(subject).to receive(attribute_reader).and_return(nil)
          expect(subject).to_not receive(:validates_with).with(validator)
          subject.valid?
        end
      end

      context "when an attribute of type #{attribute_type} is present" do
        context 'with a valid value' do
          it 'should validate that attribute correctly' do
            subject = class_with_validations.new

            allow(subject).to receive(attribute_reader).and_return(valid_value)
            expect(subject).to be_valid
          end
        end

        context 'with an invalid value' do
          it 'should validate that attribute correctly' do
            subject = class_with_validations.new

            allow(subject).to receive(attribute_reader).and_return(invalid_value)
            expect(subject).to be_invalid
          end
        end
      end
    end
  end
end
