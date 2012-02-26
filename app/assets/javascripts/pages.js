
// Render markdown from source
function render_markdown() {

    function unesc(str) {
        var tmp = document.createElement("div");
        tmp.innerHTML = str;
        return tmp.childNodes[0].nodeValue;
    }

    var node = document.getElementById('markdown-source');
    if (node) {
        node.innerHTML = new Showdown.converter().makeHtml(unesc(node.innerHTML));
        hljs.initHighlighting();
    }
}
$(document).ready(function() {
    render_markdown();
});

// Behavior for the edit page (/wikiname/pagename/edit)
$(document).ready(function() {
	resize = function() {
		var edit = $('#editor');
		var text = edit.val();
		if (text)
			edit.attr("rows", text.split("\n").length);
	}

	var edit = $('#editor');
	if (edit) {
		edit.keydown(resize);
		edit.keyup(resize);

		resize();

		edit.focus();
	}

    var editmode = $('#edit-mode');
    if (editmode) {
        editmode.click(function() {
            if (editmode.text().indexOf("Preview") != -1) {
                editmode.text("Show Editor");
                $('#source-view').hide();
                $('#preview-view').show();

                var preview = $('#preview-view');
                preview.remove('#markdown-source');
                preview.append('<div id="markdown-source"></div>');

                var src = $('#markdown-source');
                src.html($('#editor').val());
                render_markdown();
            } else {
                editmode.text("Show Preview");
                $('#source-view').show();
                $('#preview-view').hide();
            }

            return false;
        });
    }
});

