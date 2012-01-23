
Dribble
=======

Dribble is a rails-oriented authorization wrapper for the Dropbox SDK gem that

* helps make pages that need to be linked to a Dropbox account
* makes it easy to continue after the user authorizes (or denies) access
* tracks Dropbox authentication tokens client-side
* manages the Dropbox session and client objects

This is best illustrated by example:

    class Example < ApplicationController
      
      before_filter :link_to_dropbox, :only => :foo
 
      def foo
        client = Dribble::client
        # ...
      end
 
      private
 
      def link_to_dropbox
        Dribble::configure(API_KEY, API_SECRET, :app_folder, self)
        Dribble::authorize do |result|
          result.success do
            flash_success_message
            redirect_to some_page
          end
 
          result.failure do { |status| flash_error :status => status }
 
          result.cached { @was_already_authorized = true }
        end
      end
  
     #...
 
    end

