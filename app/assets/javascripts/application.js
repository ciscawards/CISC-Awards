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
//= require bootstrap
//= require_tree .
//= require bootstrap-datepicker
//= require jquery.ui.widget
//= require z.jquery.fileupload
//= require cocoon
//= require froala_editor.min.js
//= require rails.validations

$.fraola_creds = {
    toolbarStickyOffset: 50,
        key: 'PG-10dpj1xB3wwdqwI2J3B10B7B7A5F4igqknsfxyG5hcj1=='
}

$(document).ready(function(){
    $('textarea:not(.no-wysiwyg)').froalaEditor($.fraola_creds);
});

$(document).on('cocoon:after-insert', function(e, insertedItem) {
    insertedItem.find('textarea').froalaEditor($.fraola_creds);
});

$.fn.datepicker.defaults.format = "yyyy-mm-dd";