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
            element.before(inputErrorField);
            inputErrorField.find('span#input_tag').replaceWith(element);
            inputErrorField.find('label.message').attr('for', element.attr('id'));
            labelErrorField.find('label.message').attr('for', element.attr('id'));
            labelErrorField.insertAfter(label);
            labelErrorField.find('label#label_tag').replaceWith(label);
        }
        return form.find("label.message[for='" + (element.attr('id')) + "']").text(message);
    },
    remove: function(element, settings) {
        debugger;
        var errorFieldClass, form, inputErrorField, label, labelErrorField;
        form = $(element[0].form);
        errorFieldClass = $(settings.label_tag).attr('class');
        inputErrorField = element.closest("." + (errorFieldClass.replace(/\ /g, ".")));
        label = form.find("label[for='" + (element.attr('id')) + "']:not(.message)");
        labelErrorField = label.closest("." + errorFieldClass);
        if (inputErrorField[0]) {
            inputErrorField.find("#" + (element.attr('id'))).detach();
            inputErrorField.replaceWith(element);
            label.detach();
            return labelErrorField.replaceWith(label);
        }
    }
};