# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  helper_method :signed_in?

  include Auth
end
