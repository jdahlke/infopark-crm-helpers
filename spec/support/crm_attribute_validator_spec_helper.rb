# frozen_string_literal: true

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
    check_for_validity(invalid_values, false)
    check_for_empty_error_messages(invalid_values, false)
  end

  def run_specs_for_valid_values(valid_values)
    check_for_validity(valid_values, true)
    check_for_empty_error_messages(valid_values, true)
  end

  protected

  def check_for_validity(values, expectation)
    values.each do |value|
      it "should be #{expectation ? 'valid' : 'invalid'}" do
        subject.attribute = value
        expect(subject.valid?).to eq(expectation)
      end
    end
  end

  def check_for_empty_error_messages(values, expectation)
    values.each do |value|
      it "#{expectation ? 'should not' : 'should'} add error messages" do
        subject.attribute = value
        subject.valid?
        expect(subject.errors[:attribute].empty?).to eq(expectation)
      end
    end
  end
end
