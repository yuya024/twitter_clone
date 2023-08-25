# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def after_sign_in_path_for(resource)
    home_path(resource)
  end

  def sigin_in_required
    redirect_to new_user_session_path unless user_signed_in?
  end
end
