// The validator variable is a JSON Object
// The selector variable is a jQuery Object
window.ClientSideValidations.validators.local['steelwork_completion_date'] = function(element, options) {
    // Your validator code goes in here
    if (new Date(element.val()).getTime() >= new Date($('#steelwork_completion_date').data('steelwork-completion-date')).getTime()) {
        // When the value fails to pass validation you need to return the error message.
        // It can be derived from validator.message
        return options.message;
    }
};