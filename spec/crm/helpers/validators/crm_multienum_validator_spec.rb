require 'spec_helper'

describe Crm::Helpers::Validators::CrmMultienumValidator, type: :validator do
  VALID_VALUES = [2, 3, 5, 7, 11, 13, 17, 19]

  subject do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :prime_numbers
      validates_with Crm::Helpers::Validators::CrmMultienumValidator, attributes: [:prime_numbers], valid_values: VALID_VALUES
    end.new
  end

  context 'without an array-ish thing as a multienum object' do
    let(:non_array_things) do
      ['This is not a list', 1234, {}]
    end

    it 'should successfully validate' do
      non_array_things.each do |non_array_thing|
        subject.prime_numbers = non_array_thing
        expect(subject).to_not be_valid
      end
    end

    it 'should add an error message' do
      non_array_things.each do |non_array_thing|
        subject.prime_numbers = non_array_thing
        subject.validate
        expect(subject.errors[:prime_numbers]).to_not be_empty
      end
    end
  end

  context 'with an array-ish thing as a list' do
    context 'with invalid values' do
      let(:non_prime_number_lists) do
        [[2, 3, 5, 7, 9], [4]]
      end

      it 'should successfully validate' do
        non_prime_number_lists.each do |non_prime_number_list|
          subject.prime_numbers = non_prime_number_list
          expect(subject).to be_invalid
        end
      end

      it 'should add an error message' do
        non_prime_number_lists.each do |non_prime_number_list|
          subject.prime_numbers = non_prime_number_list
          subject.validate
          expect(subject.errors[:prime_numbers]).to_not be_empty
        end
      end
    end

    context 'with valid values onry' do
      let(:prime_number_lists) do
        [[2, 3, 5, 7], [2, 19]]
      end

      it 'should successfully validate' do
        prime_number_lists.each do |prime_number_list|
          subject.prime_numbers = prime_number_list
          expect(subject).to be_valid
        end
      end

      it 'should not add an error message' do
        prime_number_lists.each do |prime_number_list|
          subject.prime_numbers = prime_number_list
          subject.validate
          expect(subject.errors[:prime_numbers]).to be_empty
        end
      end
    end
  end
end
