
$(document).ready(function() {
    var toggle = $('#toggle');
    if (toggle) {
        toggle.click(function() {
            toggle.hide();
            $('#create').show();
            $('#wiki_name').focus();
            return false; 
        });
    }
});

