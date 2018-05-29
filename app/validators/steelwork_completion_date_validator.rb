class SteelworkCompletionDateValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    unless value <= record.cohort.steel_work_completed_deadline
      record.errors.add(attr_name, options.merge(value: value))
    end
  end
end

# This allows us to assign the validator in the model
module ActiveModel::Validations::HelperMethods
  def validates_steelwork_date(*attr_names)
    validates_with SteelworkDateValidator, _merge_attributes(attr_names)
  end
end