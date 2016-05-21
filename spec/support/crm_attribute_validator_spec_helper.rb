module CrmAttributeValidatorSpecHelper
  include RSpec::Mocks::ExampleMethods

  def run_specs_for_crm_attribute_validator(validator, options = {})
    describe validator, type: :validator do
      subject { setup_subject(validator, options).new }

      context 'with an invalid value' do
        run_specs_for_invalid_values(options[:invalid_values])
      end

      context 'with a valid value' do
        run_specs_for_valid_values(options[:valid_values])
      end
    end
  end

  def setup_subject(validator, options = {})
    subject_class = Class.new do
      include ActiveModel::Validations

      attr_accessor :attribute
      validates_with validator, attributes: [:attribute]

      def self.name
        'ClassWithValidations'
      end
    end

    stub_crm_attributes(subject_class, options[:crm_attributes])
  end

  def stub_crm_attributes(subject, crm_attributes)
    subject.define_singleton_method :crm_attributes do
      crm_attributes.presence || {}
    end
    subject
  end

  def run_specs_for_invalid_values(invalid_values)
    invalid_values.each do |invalid_value|
      it 'should successfully validate and add an error message' do
        subject.attribute = invalid_value
        expect(subject).to_not be_valid
        expect(subject.errors[:attribute]).to_not be_empty
      end
    end
  end

  def run_specs_for_valid_values(valid_values)
    valid_values.each do |valid_value|
      it 'should successfully validate and not add errors' do
        subject.attribute = valid_value
        expect(subject).to be_valid
        expect(subject.errors[:attribute]).to be_empty
      end
    end
  end
end
