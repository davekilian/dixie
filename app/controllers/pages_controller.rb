class PagesController < ApplicationController

	require 'wiki-name.rb'
	require 'dribble.rb'

	def show
		get_page
		@header_links = :show
	end

	def edit
		get_page
		@header_prefix = 'Editing'
		@header_links = :edit
	end

	def save
		put_page
		redirect_to "/#{params[:wiki]}/#{params[:page]}"
	end

private

	def get_page
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
						found = true
						yield wikiurl, pageurl, baseurl, contents if block_given?
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

	def put_page
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)
		if Dribble::authorized?
			@wikiurl = params[:wiki]
			@pageurl = params[:page]
			@baseurl = "/#{@wikiurl}/#{@pageurl}"
			@contents = params[:markdown]

			logger.info @baseurl
			logger.info @contents

			client = Dribble::client
			client.put_file "#{@baseurl}.md", @contents, true
		end
	end

end

