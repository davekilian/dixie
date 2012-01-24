
# A rails-oriented wrapper for authorization and session management with the
# Dropbox SDK gem.
#
#   class Example < ApplicationController
#     
#     before_filter :link_to_dropbox, :only => :foo
#
#     def foo
#       client = Dribble::client
#       # ...
#     end
#
#     private
#
#     def link_to_dropbox
#       Dribble::configure(API_KEY, API_SECRET, :app_folder, self)
#       Dribble::authorize do |result|
#         result.success do
#           flash_success_message
#           redirect_to some_page
#         end
#
#         result.failure do { |status| flash_error :status => status }
#
#         result.cached { @was_already_authorized = true }
#       end
#     end
#
#     #...
#
#   end
class Dribble < ActionController::Base
	
	require 'dropbox_sdk'

	# Sets configuration options about this app. This must be called
	# before using other Dribble methods.
	#
	# [+api_key+]     your app's Dropbox API key
	# 
	# [+api_secret+]  the secret paired with your +api_key+
	#
	# [+access_mode+] the way your app interacts with the user's Dropbox
	#                 account. Should be
	#
	#                 * +:app_folder+ if your app is sandboxed
	#                 * +:dropbox+ if your app uses the entire account
	#
	#                 See the Dropbox API docs for further reference
	#
	# [+controller+]  The controller loading the current page. This
	#                 object is used to manage the Dropbox tokens stored
	#                 in the session and for creating redirects
	def self.configure(api_key, api_secret, access_mode, controller)
		@@api_key = api_key
		@@api_secret = api_secret
		@@access_mode = access_mode
		@@controller = controller
		@@authorized = false
	end

	# When the user visits your page organically, this method call checks 
	# if the app is authorized to access the user's Dropbox account. If it
	# isn't, this method redirects to a page that lets the user allow or
	# deny your app access to the user's Dropbox account. 
	#
	# When the user makes a decision, Dropbox redirects back to the page
	# that originally called +authorize+ with a special GET parameter.
	# When +authorize+ is called in this context, it finishes the 
	# authorization process and executes a block containing a +result+ 
	# object. 
	#
	# The +result+ object has three methods that execute a block if they
	# correspond to the result of the authorization attempt.
	#
	# * +result.success+ executes a block if the user authorized the 
	#   application
	#
	# * +result.failed+ executes a block if the user denied access or
	#   something else went wrong. The first parameter to the block
	#   contains the status code returned by the Dropbox API server
	#
	# * +result.none+ executes a block if the app was already 
	#   authorized with the current user's Dropbox account
	#
	# While Dribble lets you write code that feels like Dropbox
	# authorization is encapsulated to a method call, in reality your page
	# is loaded twice: first by the user organically, and second as the
	# callback URL for the Dropbox authorization page. This means
	# +authorize+ should only be used for pages retrieved by a GET query.
	#
	# This method stores and retrieves Dropbox request and access tokens
	# in the user's cookies. This means the application only has to
	# redirect to Dropbox when it hasn't been authorized yet.
	def self.authorize()
		@@session = DropboxSession.new(@@api_key, @@api_secret)
		
		session = @@controller.session
		params = @@controller.params
		request = @@controller.request

		if authorized?
			yield DribbleResponder.new(:cached) if block_given?
		end

		if params.has_key?(:dribble_callback)
			request = params[:dribble_callback].split '-'
			@@session.set_request_token(request[0], request[1])

			begin
				@@session.get_access_token

				request_key = @@session.request_token.key
				request_secret = @@session.request_token.secret
				access_key = @@session.access_token.key
				access_secret = @@session.access_token.secret

				session[:dribble] = [ request_key, request_secret, access_key,
									  access_secret ].join '-'
		
				yield DribbleResponder.new(:success) if block_given?
			rescue DropboxAuthError => e
				yield DribbleResponder.new(:failure, 
										   e.http_response) if block_given?
			end
		else
			@@session.get_request_token
		
			rkey = @@session.request_token.key
			rsecret = @@session.request_token.secret

			callback = request.url + 
					   (request.GET.count > 0 ? '&' : '?') +
					   "dribble_callback=#{rkey}-#{rsecret}"
			
			@@controller.redirect_to @@session.get_authorize_url(callback)
		end
	end

	# If the user that requested the page has a cookie containing valid
	# Dropbox tokens, this method reconstructs the session from the tokens
	# and returns +true+. Otherwise the method returns +false+. 
	def self.authorized?
		return true if @@authorized

		@@session = DropboxSession.new(@@api_key, @@api_secret)
		session = @@controller.session

		if session.has_key?(:dribble)
			parts = session[:dribble].split '-'

			if parts.count == 4
				request_key = parts[0]
				request_secret = parts[1]
				access_key = parts[2]
				access_secret = parts[3]

				@@session.set_request_token(request_key, request_secret)
				@@session.set_access_token(access_key, access_secret)

				begin
					self.client.account_info # Make sure tokens haven't expired
					@@authorized = true
				rescue DropboxAuthError => err
					session.delete :dribble
					@@authorized = false
				end

				return @@authorized
			end
		end

		false
	end

	# Gets the +DropboxSession+ object corresponding to the authorized
	# session Dribble created. Returns +nil+ if neither Dribble::authorize
	# nor Dribble::authorized? has been called.
	def self.session
		@@session
	end

	# Gets a +DropboxClient+ object authorized through the authorized
	# session Dribble created. The client object is constructued on the
	# first call to this method and is reused until the current page
	# request is comipleted. If the application is not authorized, 
	# this method returns +nil+.
	def self.client
			@@client ||= 
				DropboxClient.new(@@session, @@access_mode) if @@session
	end

	private

	# The object passed to the optional block given to Dribble::authorize
	class DribbleResponder
		
		def initialize(result, code = 200)
			@result = result
			@code = code
		end

		def success
			yield if block_given? and @result == :success
		end

		def failure
			yield @code if block_given? and @result == :failure
		end

		def cached
			yield if block_given? and @result == :cached
		end

		def authorized?
			@result != :failure
		end

	end

end

