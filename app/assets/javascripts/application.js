// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require areyousure
//= require bootstrap
//= require bootstrap-datepicker
//= require jquery.ui.widget
//= require z.jquery.fileupload
//= require cocoon
//= require froala_editor.min.js
//= require rails.validations
//= require rails.validations.actionView
//= require rails.validations.customValidators
//= require_tree .

$.fraola_creds = {
    toolbarStickyOffset: 50,
        key: 'RH4I3B17A10iB6E5E4H5I2I3C7B6D6E5C-11bkpgC9gkjlxD-8mH4A-21D-17utE-11E1ppeB-21D-16wC2zkA-8lF-7sC5lfpriuc=='
};

$(document).ready(function(){
    $('textarea:not(.no-wysiwyg)').froalaEditor($.fraola_creds);
    $('.js_select_all').change(function() {
        var checkboxes = $(this).closest('table').find(':checkbox');
        checkboxes.prop('checked', $(this).is(':checked'));
    });
});

$(document).on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('textarea').froalaEditor($.fraola_creds);
});

$.fn.datepicker.defaults.format = "yyyy-mm-dd";
