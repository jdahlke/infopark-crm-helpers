require 'spec_helper'

describe Crm::Helpers::Persistence do
  let(:crm_type_class) { Class.new }
  let(:crm_id) { '42' }
  let(:crm_attributes) do
    {
      id: crm_id,
      language: 'en',
      first_name: 'John',
      last_name: 'Smith'
    }
  end
  let(:crm_object) do
    object = Object.new
    allow(object).to receive(:attributes).and_return(crm_attributes)
    object
  end

  let(:new_attributes) do
    {
      first_name: 'Fox',
      last_name: 'Mulder'
    }
  end

  let(:instance) do
    instance = subject.new
    crm_attributes.each_pair do |attribute, value|
      allow(instance).to receive(attribute).and_return(value)
    end
    allow(instance).to receive(:assign_attributes)
    allow(instance).to receive(:crm_attributes).and_return(crm_attributes)
    allow(instance).to receive(:crm_object).and_return(crm_object)
    instance
  end

  subject do
    class_with_crud_helpers = Class.new do
      include Crm::Helpers::Persistence

      def self.name
        'ClassWithPersistence'
      end
    end
    allow(class_with_crud_helpers).to receive(:crm_class).and_return(crm_type_class)
    class_with_crud_helpers
  end

  before :each do
    allow(crm_type_class).to receive(:find).and_return(crm_object)
  end

  describe '.create' do
    let(:instance) { subject.new }

    subject do
      Class.new do
        include Crm::Helpers::Persistence
      end
    end

    before :each do
      allow(instance).to receive(:invalid?)
      allow(instance).to receive(:save!)
      allow(subject).to receive(:new).and_return(instance)
    end

    it 'creates a new instance with attributes' do
      expect(subject).to receive(:new).with(crm_attributes)
      subject.create(crm_attributes)
    end

    context 'with valid attributes' do
      before :each do
        allow(instance).to receive(:invalid?).and_return(false)
      end

      it 'persists the instance' do
        expect(instance).to receive(:save!)
        subject.create(crm_attributes)
      end
    end

    context 'with invalid attributes' do
      before :each do
        allow(instance).to receive(:invalid?).and_return(true)
      end

      it 'does not persist the instance' do
        expect(instance).to_not receive(:save!)
        subject.create(crm_attributes)
      end
    end
  end

  describe '#save' do
    it 'calls update without attributes' do
      expect(instance).to receive(:update).with(no_args)
      instance.save
    end
  end

  describe '#save!' do
    it 'calls update! without attributes' do
      expect(instance).to receive(:update!).with(no_args)
      instance.save!
    end
  end

  describe '#destroy' do
    it 'calls #destroy on the CRM object' do
      expect(crm_object).to receive(:destroy)
      instance.destroy
    end

    it 'returns the instance' do
      allow(crm_object).to receive(:destroy)
      expect(instance.destroy).to eq(instance)
    end
  end

  describe '#update' do
    it 'merges the passed attributes and the existing attributes' do
      allow(instance).to receive(:invalid?)
      allow(instance).to receive(:persist)
      expect(instance).to receive(:assign_attributes).with(new_attributes)
      instance.update(new_attributes)
    end
  end

  describe '#update!' do
    it 'merges the passed attributes and the existing attributes' do
      allow(instance).to receive(:invalid?)
      allow(instance).to receive(:persist)
      expect(instance).to receive(:assign_attributes).with(new_attributes)
      instance.update(new_attributes)
    end
  end

  context 'with invalid data' do
    before :each do
      allow(instance).to receive(:invalid?).and_return(true)
      allow(instance).to receive(:persist).and_return(false)
    end

    describe '#update' do
      it 'returns false' do
        expect(instance.update).to eq(false)
      end

      it 'does not call #persist' do
        expect(instance).to_not receive(:persist)
        instance.update
      end
    end

    describe '#update!' do
      let(:error_message) { "#{instance.class.name} object is invalid." }

      it 'returns false' do
        expect { instance.update! }.to raise_error(error_message)
      end

      it 'does not call #persist' do
        expect(instance).to_not receive(:persist)
        expect { instance.update! }.to raise_error(error_message)
      end
    end

    describe '#persist' do
      it 'returns false' do
        expect(instance.persist).to eq(false)
      end

      it 'does not create or update anything' do
        expect(crm_type_class).to_not receive(:create)
        expect(crm_object).to_not receive(:update)
        instance.persist
      end

      it 'does not touch our CRM attributes' do
        expect(instance).to_not receive(:assign_attributes)
        instance.persist
      end
    end
  end

  context 'with valid data' do
    before :each do
      allow(instance).to receive(:invalid?).and_return(false)
      allow(crm_type_class).to receive(:create).with(crm_attributes)
      allow(crm_object).to receive(:update).with(crm_attributes)
    end

    describe '#update' do
      it 'returns true' do
        expect(instance.update).to eq(true)
      end

      it 'calls #persist' do
        expect(instance).to receive(:persist)
        instance.update
      end
    end

    describe '#update!' do
      it 'returns true' do
        expect(instance.update!).to eq(true)
      end

      it 'calls #persist' do
        expect(instance).to receive(:persist)
        instance.update!
      end
    end

    describe '#persist' do
      it 'returns true' do
        expect(instance.persist).to eq(true)
      end

      it 'modifies our CRM attributes' do
        expect(instance).to receive(:assign_attributes)
        instance.persist
      end

      context 'with a new object' do
        before :each do
          allow(instance).to receive(:id).and_return(nil)
        end

        it 'creates a new object' do
          expect(crm_type_class).to receive(:create).with(crm_attributes)
          instance.persist
        end
      end

      context 'with an existing object' do
        it 'updates the object' do
          expect(crm_object).to receive(:update).with(crm_attributes)
          instance.persist
        end

        it 'does not create a new object' do
          expect(crm_type_class).to_not receive(:create)
          instance.persist
        end
      end
    end
  end
end
