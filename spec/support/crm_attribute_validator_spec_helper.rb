# frozen_string_literal: true

module CrmAttributeValidatorSpecHelper
  include RSpec::Mocks::ExampleMethods

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

  RSpec.shared_examples 'crm attribute validator' do |validator, options = {}|
    subject { setup_subject(validator, options).new }

    context 'with an invalid value' do
      include_examples 'validity check', options[:invalid_values], false
      include_examples 'error messages', options[:invalid_values], false
    end

    context 'with a valid value' do
      include_examples 'validity check', options[:valid_values], true
      include_examples 'error messages', options[:valid_values], true
    end
  end

  RSpec.shared_examples 'validity check' do |values, expectation|
    values.each do |value|
      it "should be #{expectation ? 'valid' : 'invalid'}" do
        subject.attribute = value
        expect(subject.valid?).to eq(expectation)
      end
    end
  end

  RSpec.shared_examples 'error messages' do |values, expectation|
    values.each do |value|
      it "#{expectation ? 'should not' : 'should'} add error messages" do
        subject.attribute = value
        subject.valid?
        expect(subject.errors[:attribute].empty?).to eq(expectation)
      end
    end
  end
end
