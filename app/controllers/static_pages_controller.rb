
class StaticPagesController < ApplicationController

	before_filter :link_to_dropbox, :only => :about

	def about
	end

	def contact
	end

	def privacy
	end

private

	require 'dribble.rb'
	def link_to_dropbox
		@message = "Default"
		Dribble::configure(DROPBOX_API_KEY, DROPBOX_API_SECRET, :app_folder, self)
		Dribble::authorize do |result|
			result.success { @message = Dribble::client.account_info }
			result.failure { |code| @message = "Failed with static code #{code}" }
			result.cached  { @message = "App was already authorized" }
		end
	end

end
