
$(document).ready(function() {
	resize = function() {
		var edit = $('#editor');
		var lines = edit.val().split("\n");
		edit.attr("rows", lines.length);
	}

	var edit= $('#editor')
	edit.keydown(resize);
	edit.keyup(resize);

	resize();

	edit.focus();
})

