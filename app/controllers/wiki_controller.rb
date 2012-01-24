class WikiController < ApplicationController

	require 'wiki-name.rb'
	require 'dribble.rb'
	
	def index
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)

		if Dribble::authorized?
			@wiki = Hash.new
			client = Dribble::client

			contents = client.metadata('/')['contents']
			
			contents.each do |hash|
				url = hash['path'].split('/').last
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

	def new
	end

	def create
	end

end

