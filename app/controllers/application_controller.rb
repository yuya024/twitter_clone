# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  # rails_best_practices: disableRemoveUnusedMethodsInControllersCheck
  def after_sign_in_path_for(resource)
    home_path(resource)
  end
  # rails_best_practices: enableRemoveUnusedMethodsInControllersCheck
end
