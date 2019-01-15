class WordCountValidator < ActiveModel::EachValidator
  def validate_each(record, attr_name, value)
    if value.present? && ActionView::Base.full_sanitizer.sanitize(value).scan(/\s+|$/).length > 125
      record.errors.add(attr_name, I18n.t("activerecord.errors.models.submission.attributes.brief_description.word_count"))
    end
  end
end

# This allows us to assign the validator in the model
module ActiveModel::Validations::HelperMethods
  def validates_brief_description(*attr_names)
    validates_with WordCountValidator, _merge_attributes(attr_names)
  end
end
