class WikiController < ApplicationController

	require 'wiki-name.rb'
	require 'dribble.rb'
	
	before_filter :link_to_dropbox

	def index
		if !@authorized
			render 'static_pages/about'
		else
			@wiki = Hash.new

			client = Dribble::client

			contents = client.metadata('/')['contents']
			
			contents.each do |hash|
				url = hash['path'].split('/').last
				@wiki[url] = WikiName.from_url(url)
			end

			# TODO
			# - Test the !@authorized block works
			# - Figure out if there's some way we can ping the server to check
			#   our cached tokens are still valid. Having trouble now where I 
			#   just unlinked the application (to test the previous TODO item)
			#   and I'm getting DropboxAuthErrors because I expired tokens
			#   cached in my cookies
		end
	end

	def new
	end

	def create
	end

	private

	def link_to_dropbox
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)
		Dribble::authorize do |result|
			@authorized = result.authorized?
		end
	end

end

