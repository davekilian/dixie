
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
    // Auto-resizing
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

    // Edit/preview tab switch
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

    // Keyboard shortcut for the edit/preview switch
    var alt = false;
    $(document).keydown(function(ev) {
        if (ev.altKey) alt = true; 
        
        if (ev.keyCode == 'P'.charCodeAt(0) && alt) {
            var editmode = $('#edit-mode');
            if (editmode)
                editmode.click();

            ev.preventDefault();
            return false;
        } else if (ev.keyCode == 'S'.charCodeAt(0) && alt) {
            document.forms['source-form'].submit();
            ev.preventDefault();
            return false;
        }
    });
    $(document).keyup(function(ev) {
        if (ev.altKey) alt = false; 
    });

    // Editor textarea captures the tab key
    // Thanks stack overflow :D
    $('#editor').keydown(function (ev) {
        if (ev.keyCode == 9) {
            var tab = "\t";
            var start = this.selectionStart;
            var end = this.selectionEnd;
            var scroll = this.scrollTop;

            this.value = this.value.substring(0, start) + tab + this.value.substring(end, this.value.length);

            this.focus();
            this.selectionStart  = this.selectionEnd = start + 1;
            this.scrollTop = scroll;
            
            ev.preventDefault();
        }
    });
});

