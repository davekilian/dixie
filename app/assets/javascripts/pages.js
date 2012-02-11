
$(document).ready(function() {
	resize = function() {
		var edit = $('#editor');
		var text = edit.val();
		if (text)
			edit.attr("rows", text.split("\n").length);
	}

	var edit= $('#editor');
	if (edit) {
		edit.keydown(resize);
		edit.keyup(resize);

		resize();

		edit.focus();
	}
})

