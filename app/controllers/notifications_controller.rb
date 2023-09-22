# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :sigin_in_required, only: %i[index]

  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page])
  end
end
