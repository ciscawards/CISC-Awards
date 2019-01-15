class WordCountValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    if value.present?
      max_word_count_const_name = attr_name.to_s.concat("_length").upcase.to_sym
      max_word_count = record.class.name.constantize.const_get(max_word_count_const_name)
      value_word_count = ActionView::Base.full_sanitizer.sanitize(value).scan(/\s+|$/).length
      if value_word_count > max_word_count
        record.errors.add(attr_name, I18n.t("activerecord.errors.models.#{record.class.name.underscore}.attributes.#{attr_name.to_s}.word_count"))
      end
    end
  end
end

# This allows us to assign the validator in the model
module ActiveModel::Validations::HelperMethods
  def validates_brief_description(*attr_names)
    validates_with WordCountValidator, _merge_attributes(attr_names)
  end
end
