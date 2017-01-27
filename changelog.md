### 1.3.0

- Add `Crm::Helpers::Persistence.create!`.
- An instance of `Crm::Errors::InvalidValues` is raised for `!`-methods, if an invalid object is to be persisted.  

### 1.2.2

- Allow indifferent access on the hash passed in whilst creating an object.

### 1.2.1

- Fix issue, wherein Rails < 5.0 was not accepted anymore.

### 1.2.0

- `.find` (from `Crm::Helpers::Finders`) is capable of fetching multiple CRM objects for multiple CRM ids.
- Added support for Rails 5.0.x.

### 1.1.2

- Use `valid_values` of a `language` attribute provided by `Crm::Type#standard_attribute_definitions`, now that the `valid_values` array contains the correct values.

### 1.1.1

- Include `Crm::Helpers::Finders` and `Crm::Helpers::Persistence` automagically when including `Crm::Helper`.
- Rename `assign_attributes` to `assign_crm_attributes`, deprecating `assign_attributes` in the near future.

### 1.1.0

- Add `assign_attributes` to `Crm::Helpers::Attributes`.
- Add `Crm::Helpers::Finders`, which provides `.find` and `find_by_query`.
- Add `Crm::Helpers::Persistence`, which provides `.create`, `#save`, `#save!`, `#update`, `#update!`, and `#destroy`.

### 1.0.2

- Fix an issue wherein some `crm_attr_reader` were not created correctly.

### 1.0.1

- Add `infopark-crm-helpers.rb` and `infopark_crm_helpers.rb` (for people who prefer underscores, i. e. `require 'infopark_crm_helpers'`) for easier Rails autoloading.

### 1.0.0

- Initial release.
