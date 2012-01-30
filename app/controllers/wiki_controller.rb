class WikiController < ApplicationController

	require 'wiki-name.rb'
	require 'dribble.rb'
	
	def index
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)

		if Dribble::authorized?
			@wiki = Hash.new
			client = Dribble::client

			contents = client.metadata('/')['contents']
			
			contents.each do |file|
				url = file['path'].split('/').last
				@wiki[url] = WikiName.from_url(url)
			end
		else
			render 'static_pages/about'
		end
	end

	def login
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)
		Dribble::authorize do |result|
			redirect_to root_path
		end
	end

	def create
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)
		if Dribble::authorized?
			name = params['wiki_name']
			url = WikiName.to_url(name)
			client = Dribble::client
			client.file_create_folder(url)
			
			# TODO
			# - Create the main-page from a template asset
			# - Redirect to that main page instead of this list
			index
		   	render 'wiki/index'
		end
	end

end

