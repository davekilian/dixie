
class WikiName

	def self.from_url(url)
		url.split('-').map { |str| str.capitalize }.join(' ')
	end

end
