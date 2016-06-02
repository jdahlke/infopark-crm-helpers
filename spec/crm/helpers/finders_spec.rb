require 'spec_helper'

describe Crm::Helpers::Finders do
  let(:crm_class) { Class.new }
  let(:crm_id) { '42' }
  let(:crm_object_attributes) do
    {
      id: crm_id,
      first_name: 'Fox',
      last_name: 'Mulder'
    }
  end
  let(:crm_object) do
    object = Object.new
    allow(object).to receive(:attributes).and_return(crm_object_attributes)
    object
  end

  subject do
    class_with_finders = Class.new do
      extend Crm::Helpers::Finders

      def self.crm_class; end

      def initialize(_); end
    end
    allow(class_with_finders).to receive(:crm_class).and_return(crm_class)
    class_with_finders
  end

  context 'when included' do
    subject do
      Class.new do
        include Crm::Helpers::Finders
      end
    end

    it 'provides the public class methods' do
      Crm::Helpers::Finders.public_instance_methods.each do |method|
        expect(subject.methods).to include(method)
      end
    end
  end

  describe '#find' do
    it 'calls .find on its CRM class' do
      expect(crm_class).to receive(:find).with(crm_id)
      subject.find(crm_id)
    end

    context 'with an id for a non-existent object' do
      before :each do
        allow(crm_class).to receive(:find).and_return(nil)
      end

      it 'returns nil' do
        expect(subject.find(crm_id)).to be_nil
      end
    end

    context 'with an id for an existing object' do
      before :each do
        allow(crm_class).to receive(:find).and_return(crm_object)
      end

      it 'creates a new instance with the CRM object attributes' do
        expect(subject).to receive(:new).with(crm_object.attributes)
        subject.find(crm_id)
      end
    end
  end

  describe '#find_by_query' do
    let(:search_result) { [crm_object, crm_object] }
    let(:search_configurator) do
      search_configurator = Object.new
      allow(search_configurator).to receive(:to_a).and_return(search_result)
      allow(search_configurator).to receive(:sort_order).and_return(search_configurator)
      allow(search_configurator).to receive(:limit).and_return(search_configurator)
      search_configurator
    end
    let(:query) { 'Derp' }

    before :each do
      allow(crm_class).to receive(:query).and_return(search_configurator)
    end

    it 'queries the CRM class' do
      expect(crm_class).to receive(:query).with(query)
      subject.find_by_query(query)
    end

    it 'returns a list of instances' do
      result = subject.find_by_query(query)
      result.each do |object|
        expect(object).to be_a(subject)
      end
    end

    it 'returns an instance for each search result' do
      expect(subject).to receive(:new).exactly(search_result.size)
      expect(subject.find_by_query(query).size).to eq(search_result.size)
    end

    context 'with a custom limit' do
      let(:custom_limit) { 10 }

      it 'uses the custom limit' do
        expect(search_configurator).to receive(:limit).with(custom_limit)
        subject.find_by_query(query, limit: custom_limit)
      end
    end

    context 'with a custom sort order' do
      let(:custom_sort_order) { 'asc' }

      it 'uses the custom sort order' do
        expect(search_configurator).to receive(:sort_order).with(custom_sort_order)
        subject.find_by_query(query, sort_order: custom_sort_order)
      end
    end
  end
end
