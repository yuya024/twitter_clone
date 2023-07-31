# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def after_sign_in_path_for(resource)
    home_path(resource)
  end
end
