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
    let(:methods) { %i(first_name last_name) }

    context 'with undefined reader methods' do
      it 'should define reader methods' do
        subject.represents_crm_type(:contact)
        subject.crm_attr_reader(*methods)
        instance = subject.new

        methods.each do |method|
          expect(method).to be_in(instance.methods)
        end
      end
    end

    context 'with already defined reader methods' do
      subject do
        Class.new do
          include Crm::Helpers::Attributes

          represents_crm_type :contact
          crm_attr_reader(*methods)

          def first_name
            'Bob'
          end

          def last_name
            'Builder'
          end
        end.new
      end

      it 'should not overwrite the existing reader method definitions' do
        expect(subject.first_name).to eq('Bob')
        expect(subject.last_name).to eq('Builder')
      end
    end
  end

  describe '.crm_attr_reader' do
    let(:crm_methods) { %i(first_name last_name) }

    context 'with undefined reader methods' do
      it 'should define reader methods' do
        subject.represents_crm_type(:contact)
        subject.crm_attr_reader(*crm_methods)
        instance = subject.new

        crm_methods.each do |crm_method|
          expect(crm_method).to be_in(instance.methods)
        end
      end

      it 'should add the reader methods to .crm_attr_readers' do
        subject.represents_crm_type(:contact)
        subject.crm_attr_reader(*crm_methods)

        expect(subject.crm_attr_readers).to eq(%i(first_name language last_name))
      end
    end

    context 'with already defined reader methods' do
      subject do
        Class.new do
          include Crm::Helpers::Attributes

          represents_crm_type :contact
          crm_attr_reader :first_name, :last_name

          def first_name
            'Bob'
          end

          def last_name
            'Builder'
          end
        end
      end

      it 'should not overwrite the existing reader method definitions' do
        instance = subject.new

        expect(instance.first_name).to eq('Bob')
        expect(instance.last_name).to eq('Builder')
      end

      it 'should add the reader methods to .crm_attr_readers' do
        expect(subject.crm_attr_readers).to eq(%i(first_name language last_name))
      end
    end
  end

  describe '.crm_attr_writer' do
    let(:crm_methods) { %i(first_name last_name) }

    context 'with undefined writer methods' do
      it 'should define writer methods' do
        subject.represents_crm_type(:contact)
        subject.crm_attr_writer(*crm_methods)
        instance = subject.new

        crm_methods.each do |crm_method|
          expect("#{crm_method}=".to_sym).to be_in(instance.methods)
        end
      end

      it 'should add the reader methods to .crm_attr_readers' do
        subject.represents_crm_type(:contact)
        subject.crm_attr_writer(*crm_methods)

        expect(subject.crm_attr_writers).to eq(%i(first_name= language= last_name=))
      end
    end

    context 'with already defined writer methods' do
      subject do
        Class.new do
          include Crm::Helpers::Attributes

          represents_crm_type :contact
          crm_attr_reader :first_name, :last_name
          crm_attr_writer :first_name, :last_name

          def first_name=(value)
            @crm_attributes[:first_name] = value.upcase
          end

          def last_name=(value)
            @crm_attributes[:last_name] = value.upcase
          end
        end
      end

      pending 'should not overwrite the existing writer method definitions' do
        instance = subject.new
        instance.first_name = 'Bob'
        instance.last_name = 'Builder'

        expect(instance.first_name).to eq('BOB')
        expect(instance.last_name).to eq('BUILDER')
      end

      it 'should add the reader methods to .crm_attr_readers' do
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
