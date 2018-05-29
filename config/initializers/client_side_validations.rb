# ClientSideValidations Initializer

# Disabled validators
# ClientSideValidations::Config.disabled_validators = []

# Uncomment to validate number format with current I18n locale
# ClientSideValidations::Config.number_format_with_locale = true

# Uncomment the following block if you want each input field to have the validation messages attached.
#
# Note: client_side_validation requires the error to be encapsulated within
# <label for="#{instance.send(:tag_id)}" class="message"></label>
#
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  if html_tag =~ /^<label/
    # This is where the label setting comes from, however the passed in label has no message attribute, so this does not
    # display the error message.
    %(<div class="field_with_errors">#{html_tag}<label for="#{instance.send(:tag_id)}" class="inline-error message"> #{instance.error_message.first}</label></div>).html_safe
  else
    # This will become the new input field wrapped with this error div and the error message will be in this label with
    # a wrapping div.
    %(<div class="field_with_errors">#{html_tag}</div>).html_safe
  end
end
