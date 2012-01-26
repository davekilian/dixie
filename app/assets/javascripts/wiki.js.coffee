
$('document').ready ->
	$('#toggle').click ->
		$('#toggle').hide()
		$('#create').show()
		$('#wiki_name').focus()

		return false

