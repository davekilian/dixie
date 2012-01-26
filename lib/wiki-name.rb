
class WikiName

	def self.from_url(url)
		url.split('-').map { |str| str.capitalize }.join(' ')
	end

	def self.to_url(name)
		name.split(' ').map { |str| str.downcase }.join('-')
	end

end
