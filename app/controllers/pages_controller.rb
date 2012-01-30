class PagesController < ApplicationController

	require 'wiki-name.rb'
	require 'dribble.rb'

	def show
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)
		if Dribble::authorized?
			@wikiurl = params[:wiki]
			@pageurl = params.has_key?(:page) ? params[:page] : 'main-page'
			@baseurl = "/#{@wikiurl}/#{@pageurl}"
			client = Dribble::client
			begin
				dir = client.metadata("/#{@wikiurl}")['contents']
				found = false

				dir.each do |file|
					if file['path'].split('/').last == @pageurl + '.md'
						@contents = client.get_file file['path']
						logger.info @metadata
						found = true
						break
					end
				end
			rescue DropboxError
				render 'pages/wiki-not-found'
			end

			if !found
				render 'pages/page-not-found'
			end
		end
	end

end

