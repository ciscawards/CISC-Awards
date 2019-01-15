window.ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] = {
  add: function(element, settings, message) {
    var form, inputErrorField, label, labelErrorField;
    form = $(element[0].form);
    if (element.data('valid') !== false && (form.find("label.message[for='" + (element.attr('id')) + "']")[0] == null)) {
      inputErrorField = $(settings.input_tag);
      labelErrorField = $(settings.label_tag);
      label = form.find("label[for='" + (element.attr('id')) + "']:not(.message)");
      if (element.attr('autofocus')) {
        element.attr('autofocus', false);
      }

      if (element.is('textarea')){
        element = element.parent().children('.fr-box, textarea')
      }
      inputErrorField.find('span#input_tag').replaceWith(element);
      inputErrorField.find('label.message').attr('for', element.attr('id'));
      labelErrorField.find('label.message').attr('for', element.attr('id'));
      labelErrorField.insertAfter(label);
      labelErrorField.find('label#label_tag').replaceWith(label);
    }
    return form.find("label.message[for='" + (element.attr('id')) + "']").text(message);
  },
  remove: function(element, settings) {
    var errorFieldClass, form, inputErrorField, label, labelErrorField;
    // Whole Form
    form = $(element[0].form);
    // "field_with_errors"
    errorFieldClass = $(settings.label_tag).attr('class');
    // This is the full input element, text_area is nested within
    inputErrorField = element.closest("." + (errorFieldClass.replace(/\ /g, ".")));
    // This is just the label, no error message with this
    label = form.find("label[for='" + (element.attr('id')) + "']:not(.message)");
    // This is the whole error field
    labelErrorField = label.closest("." + errorFieldClass);
    if (inputErrorField[0]) {
      // This removes the text_area element
      inputErrorField.find("#" + (element.attr('id'))).detach();
      // TODO: This is where things are borking
      inputErrorField.replaceWith(element);
      label.detach();
      return labelErrorField.replaceWith(label);
    }
  }
};
