require 'spec_helper'

describe Crm::Helpers::Validators::CrmListValidator, type: :validator do
  subject do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :list
      validates_with Crm::Helpers::Validators::CrmListValidator, attributes: [:list]
    end.new
  end

  context 'without an array-ish thing as a list' do
    let(:non_array_things) do
      ['This is not a list', 1234, {}]
    end

    it 'should successfully validate' do
      non_array_things.each do |non_array_thing|
        subject.list = non_array_thing
        expect(subject).to_not be_valid
      end
    end

    it 'should add an error message' do
      non_array_things.each do |non_array_thing|
        subject.list = non_array_thing
        subject.valid?
        expect(subject.errors[:list]).to_not be_empty
      end
    end
  end

  context 'with an array-ish thing as a list' do
    let(:array_things) do
      [[2, 3, 5, 7]]
    end

    it 'should successfully validate' do
      array_things.each do |array_thing|
        subject.list = array_thing
        expect(subject).to be_valid
      end
    end

    it 'should not add an error message' do
      array_things.each do |array_thing|
        subject.list = array_thing
        subject.valid?
        expect(subject.errors[:list]).to be_empty
      end
    end
  end
end
