require 'spec_helper'

describe Crm::Helpers::Validators::CrmDatetimeValidator, type: :validator do
  subject do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :datetime
      validates_with Crm::Helpers::Validators::CrmDatetimeValidator, attributes: [:datetime]
    end.new
  end

  context 'without a Date/Time/Datetime thing as datetime' do
    let(:non_datetime_things) do
      ['This is not a list', 1234, {}]
    end

    it 'should successfully validate' do
      non_datetime_things.each do |non_datetime_thing|
        subject.datetime = non_datetime_thing
        expect(subject).to_not be_valid
      end
    end

    it 'should add an error message' do
      non_datetime_things.each do |non_datetime_thing|
        subject.datetime = non_datetime_thing
        subject.validate
        expect(subject.errors[:datetime]).to_not be_empty
      end
    end
  end

  context 'with Date/Time/Datetime thing as datetime' do
    let(:datetime_things) do
      [Date.today, Time.now, DateTime.now]
    end

    it 'should successfully validate' do
      datetime_things.each do |datetime_thing|
        subject.datetime = datetime_thing
        expect(subject).to be_valid
      end
    end

    it 'should not add errors' do
      datetime_things.each do |datetime_thing|
        subject.datetime = datetime_thing
        subject.validate
        expect(subject.errors[:datetime]).to be_empty
      end
    end
  end
end
