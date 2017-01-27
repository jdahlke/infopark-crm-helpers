[![infopark-crm-helpers gem version on rubygems.org](https://badge.fury.io/rb/infopark-crm-helpers.svg)](https://badge.fury.io/rb/infopark-crm-helpers)
[![infopark-crm-helpers build status on Travis CI](https://travis-ci.org/Skudo/infopark-crm-helpers.svg?branch=develop)](https://travis-ci.org/Skudo/infopark-crm-helpers)
[![infopark-crm-helpers on CodeClimate](https://codeclimate.com/github/Skudo/infopark-crm-helpers/badges/gpa.svg)](https://codeclimate.com/github/Skudo/infopark-crm-helpers)
[![infopark-crm-helpers test coverage on CodeClimate](https://codeclimate.com/github/Skudo/infopark-crm-helpers/badges/coverage.svg)](https://codeclimate.com/github/Skudo/infopark-crm-helpers/coverage)

# infopark-crm-helpers

[Infopark WebCRM](https://infopark.com) is a cloud-based CRM. This gem `infopark-crm-helpers` addresses two "annoying" things when you have your own classes and want to use the WebCRM as a data store.

* `Crm::Contact` and its friends don't provide setters for attributes and if you build your own classes around them, you will find that collecting all the relevant attributes with which to call `#update` (or `#create`) can be a bit tedious.
* There is no easy way to validate your objects against the type definitions set up in the WebCRM. You however want to validate your entire object before you try to write your data to the WebCRM, because not doing so can cause an awkward user experience: You validate the object to match _your_ expectations of what a valid object is and the user works on fixing their input to match _your_ expectations. Then, you send your data to the WebCRM and... it tells you your data is invalid. The user will have to deal with another round of fixing their input, which can end up in nasty tableflips.

`infopark-crm-helpers` attempts to address these things in a convenient way.

## Installation

Add 'infopark-crm-helpers' into your `Gemfile`.

```
gem 'infopark-crm-helpers`
```

Install the gem with [Bundler](https://bundler.io/).

```
bundle install
```

## Configuration

No direct configuration of `infopark-crm-helpers` is required. Refer to [infopark/webcrm_sdk](https://github.com/infopark/webcrm_sdk#configuration) for instructions on setting up your installation of `infopark_webcrm_sdk`.

### Run specs

Add your CRM credentials to `.crm.yml` in the root folder of this project.

```yaml
tenant: your-tenant-here
login: john.smith@example.org
api_key: 1234567890abcdefghijklmnopqrstuvwxyz
```

Then invoke:

```
bundle exec rake spec
```

## Examples

### Create your own class

Let's build a class `Customer` which is based on WebCRM contacts.

```ruby
class Customer
  include Crm::Helpers::Attributes

  represents_crm_type :contact
end

Customer.mandatory_crm_attributes
# => [:language, :last_name]

Customer.crm_attributes[:language]
# => {"attribute_type"=>"enum", "create"=>true, "mandatory"=>true, "read"=>true,
# "title"=>"Language", "update"=>true, "valid_values"=>["de", "en"]}

Customer.crm_attributes[:last_name]
# => {"attribute_type"=>"string", "create"=>true, "mandatory"=>true,
# "read"=>true, "title"=>"Last Name", "update"=>true}
```

### Use attributes from the CRM contact

```ruby
class Customer
  include Crm::Helpers::Attributes

  represents_crm_type :contact

  crm_attr_accessor :first_name, :last_name, :email
end

customer = Customer.new
# => #<Customer>

customer.first_name = 'Huy'
# => "Huy"

customer.last_name = 'Dinh'
# => "Dinh"

customer.email = 'huy.dinh@infopark.de'
# => "huy.dinh@infopark.de"

customer.crm_attributes
# => {:first_name=>"Huy", :last_name=>"Dinh", :email=>"huy.dinh@infopark.de"}
```

### Validate an object

```ruby
class Customer
  include ActiveModel::Validations
  include Crm::Helpers::Attributes

  represents_crm_type :contact

  crm_attr_accessor :first_name, :last_name, :email
  validates_with Crm::Helpers::Validators::CrmTypeValidator
end

customer = Customer.new
# => #<Customer>

customer.valid?
# => false

customer.errors
# => #<ActiveModel::Errors @base=#<Customer:0x007feb8f3b3d00
# @validation_context=nil, @errors=#<ActiveModel::Errors:0x007feb8f381dc8 ...>,
# @crm_attributes={}>, @messages={:language=>["can't be blank"],
# :last_name=>["can't be blank"]}>```
```

### Fetch and update an object

```ruby
class Customer
  include ActiveModel::Validations
  include Crm::Helpers::Attributes

  represents_crm_type :contact

  crm_attr_accessor :first_name, :last_name, :email
  validates_with Crm::Helpers::Validators::CrmTypeValidator

  def self.find(crm_id)
    crm_contact = Crm::Contact.find(crm_id)
    return nil if crm_contact.nil?

    new(crm_contact.attributes)
  end

  def initialize(attributes = {})
    @crm_attributes = attributes.dup
  end

  def save
    return false if invalid?

    crm_contact = Crm::Contact.find(crm_id)
    crm_contact.update(crm_attributes)
    @crm_attributes = crm_contact.attributes
    true
  end
end

customer = Customer.find('fc851ba935f8420824498aee739ac897')
# => #<Customer>

customer.last_name
# => "Dinh"

customer.first_name
# => "Huy"

customer.last_name = 'Smith'
# => "Smith"

customer.first_name = 'John'
# => "John"

customer.save
# true

same_customer = Customer.find('fc851ba935f8420824498aee739ac897')
# => #<Customer>

same_customer.last_name
# => "Smith"

same_customer.first_name
# => "John"
```

## Validators

Each CRM attribute type has its own validator:

  * `Crm::Helpers::Validators::CrmBooleanValidator`
  * `Crm::Helpers::Validators::CrmDatetimeValidator`
  * `Crm::Helpers::Validators::CrmEnumValidator`
  * `Crm::Helpers::Validators::CrmIntegerValidator`
  * `Crm::Helpers::Validators::CrmListValidator`
  * `Crm::Helpers::Validators::CrmMultienumValidator`
  * `Crm::Helpers::Validators::CrmStringValidator`
  * `Crm::Helpers::Validators::CrmTextValidator`

You can use those to explicitly validate attributes for a certain format.

```ruby
validates_with Crm::Helpers::Validators::CrmBooleanValidator,
               attributes: [:custom_has_ps4, :custom_has_xbox_one]
```

## Finders

```ruby
class Customer
  include ActiveModel::Validations
  include Crm::Helpers::Attributes
  include Crm::Helpers::Finders

  represents_crm_type :contact

  crm_attr_accessor :first_name, :last_name, :email
  validates_with Crm::Helpers::Validators::CrmTypeValidator

  def initialize(attributes = {})
    @crm_attributes = attributes.dup
  end
end

customer = Customer.find('fc851ba935f8420824498aee739ac897')
# => #<Customer>
```

## Persistence

```ruby
class Customer
  include ActiveModel::Validations
  include Crm::Helpers::Attributes
  include Crm::Helpers::Persistence

  represents_crm_type :contact

  crm_attr_accessor :first_name, :last_name, :email
  validates_with Crm::Helpers::Validators::CrmTypeValidator

  def initialize(attributes = {})
    @crm_attributes = attributes.dup
  end
end

customer = Customer.create(language: 'en', last_name: 'Dinh')
# => #<Customer>

customer.language = 'de'
# => 'de'

customer.save
# => true

customer.update(language: 'en')
# => true

customer.destroy
# => #<Customer>
```
