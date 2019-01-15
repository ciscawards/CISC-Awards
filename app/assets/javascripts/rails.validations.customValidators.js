// The validator variable is a JSON Object
// The selector variable is a jQuery Object
window.ClientSideValidations.validators.local['steelwork_completion_date'] = function(element, options) {
  if (new Date(element.val()).getTime() >= new Date($('#steelwork_completion_date').data('steelwork-completion-date')).getTime()) {
    return options.message;
  }
};

window.ClientSideValidations.validators.local['word_count'] = function(element, options) {
  if (element.val().replace(/<(?:.|\n)*?>/gm, '').split(" ").length > element.data("maxWords")){
    return options.message;
  }
};
