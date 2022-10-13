class Web::ApplicationController < ApplicationController
  helper_method :signed_in?
  
  include Auth
end