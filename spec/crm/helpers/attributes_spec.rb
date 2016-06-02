require 'spec_helper'

describe Crm::Helpers::Attributes do
  let(:crm_attributes) do
    {
      not_mandatory: { mandatory: false },
      not_mandatory_either: { mandatory: false },
      mandatory: { mandatory: true },
      amanda_tory: { mandatory: true }
    }.with_indifferent_access
  end

  let(:mandatory_attributes) do
    %i(amanda_tory mandatory)
  end

  let(:data) do
    {
      language: 'en',
      first_name: 'Amanda',
      last_name: 'Tory'
    }
  end

  subject do
    Class.new do
      include Crm::Helpers::Attributes
    end
  end

  describe '.mandatory_crm_attributes' do
    it 'should return an array with mandatory attributes' do
      allow(subject).to receive(:crm_attributes).and_return(crm_attributes)
      expect(subject.mandatory_crm_attributes).to eq(mandatory_attributes)
    end
  end

  describe '.represents_crm_type' do
    context 'with no CRM type' do
      it 'should raise an error' do
        expect { subject.represents_crm_type(nil) }.to raise_error(RuntimeError)
      end
    end

    context 'with an invalid CRM type' do
      it 'should raise an error' do
        expect { subject.represents_crm_type(:does_not_exist) }.to raise_error(Crm::Errors::ResourceNotFound)
      end
    end

    context 'with a valid CRM type' do
      it 'should set the CRM type for this object' do
        crm_type = :account
        subject.represents_crm_type(crm_type)
        expect(subject.crm_type).to eq(crm_type)
      end

      it 'should call .crm_attr_accessor with all mandatory attributes' do
        allow(subject).to receive(:crm_attributes).and_return(crm_attributes)
        expect(subject).to receive(:crm_attr_accessor).with(*mandatory_attributes)

        subject.represents_crm_type(:contact)
      end
    end
  end

  describe '.crm_attributes' do
    it 'should return a hash' do
      crm_type = :contact
      subject.represents_crm_type(crm_type)
      expect(subject.crm_attributes).to be_kind_of(Hash)
    end

    context 'when setting the CRM type' do
      it 'should update the CRM attributes data' do
        subject.represents_crm_type(:account)
        first_crm_attributes = subject.crm_attributes

        subject.represents_crm_type(:contact)
        expect(subject.crm_attributes).to_not eq(first_crm_attributes)
      end
    end
  end

  describe '.crm_attr_reader' do
    let(:crm_methods) { %i(first_name last_name) }

    context 'with undefined reader methods' do
      let(:crm_methods) { %i(home_page name) }

      let(:data) do
        {
          name: 'Infopark AG',
          home_page: 'https://infopark.com'
        }
      end

      before :each do
        subject.represents_crm_type(:account)
        subject.crm_attr_reader(*crm_methods)
        allow(subject).to receive(:crm_attributes).and_return(data)
      end

      it 'should define reader methods' do
        instance = subject.new

        crm_methods.each do |crm_method|
          expect(crm_method).to be_in(instance.methods)
        end
      end

      it 'should add the reader methods to .crm_attr_readers' do
        expect(subject.crm_attr_readers).to eq(%i(home_page name))
      end

      it 'should read from the crm_attributes hash' do
        instance = subject.new

        data.keys.each do |attribute|
          expect(instance.send(attribute)).to eq(instance.crm_attributes[attribute])
        end
      end
    end

    context 'with already defined reader methods' do
      subject do
        Class.new do
          include Crm::Helpers::Attributes

          represents_crm_type :contact
          crm_attr_reader :first_name, :last_name

          def first_name
            'Amanda'
          end

          def last_name
            'Tory'
          end
        end
      end

      it 'should not overwrite the existing reader method definitions' do
        instance = subject.new

        expect(instance.first_name).to eq('Amanda')
        expect(instance.last_name).to eq('Tory')
      end

      it 'should add the reader methods to .crm_attr_readers' do
        expect(subject.crm_attr_readers).to eq(%i(first_name language last_name))
      end
    end
  end

  describe '.crm_attr_writer' do
    let(:crm_methods) { %i(first_name last_name) }

    context 'with undefined writer methods' do
      before :each do
        subject.represents_crm_type(:contact)
        subject.crm_attr_writer(*crm_methods)
      end

      it 'should define writer methods' do
        instance = subject.new

        crm_methods.each do |crm_method|
          expect("#{crm_method}=".to_sym).to be_in(instance.methods)
        end
      end

      it 'should add the writer methods to .crm_attr_writers' do
        expect(subject.crm_attr_writers).to eq(%i(first_name= language= last_name=))
      end

      it 'should write into the crm_attributes hash' do
        instance = subject.new

        data.each_pair do |attribute, value|
          instance.send("#{attribute}=", value)
          expect(instance.crm_attributes[attribute]).to eq(value)
        end
      end
    end

    context 'with already defined writer methods' do
      subject do
        Class.new do
          include Crm::Helpers::Attributes

          represents_crm_type :contact
          crm_attr_reader :first_name, :last_name
          crm_attr_writer :first_name, :last_name

          def initialize
            @crm_attributes = {}
          end

          def first_name=(value)
            @crm_attributes[:first_name] = value.upcase
          end

          def last_name=(value)
            @crm_attributes[:last_name] = value.upcase
          end
        end
      end

      it 'should not overwrite the existing writer method definitions' do
        instance = subject.new
        instance.first_name = 'Amanda'
        instance.last_name = 'Tory'

        expect(instance.first_name).to eq('AMANDA')
        expect(instance.last_name).to eq('TORY')
      end

      it 'should add the writer methods to .crm_attr_writers' do
        expect(subject.crm_attr_writers).to eq(%i(first_name= language= last_name=))
      end
    end
  end

  describe '.crm_attr_accessor' do
    let(:crm_methods) do
      %i(first_name last_name email)
    end

    it 'should call .crm_attr_reader and .crm_attr_writer' do
      expect(subject).to receive(:crm_attr_reader).with(*crm_methods)
      expect(subject).to receive(:crm_attr_writer).with(*crm_methods)
      subject.crm_attr_accessor(*crm_methods)
    end
  end
end
