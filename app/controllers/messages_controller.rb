# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :sigin_in_required, only: [:create]

  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      redirect_to room_path(params[:id], user_id: params[:user_id])
    else
      @rooms = current_user.room_list
      @room = UserRoom.find_by!(room_id: params[:id], user_id: params[:user_id])
      @messages = Message.includes(:user).where(room_id: params[:id])
      @error_messages = @message.errors.full_messages
      render 'rooms/show', status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content).merge(room_id: params[:id])
  end
end
