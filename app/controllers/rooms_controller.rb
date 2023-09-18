# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :sigin_in_required, only: %i[index create show]

  def index
    @rooms = current_user.room_list
  end

  def create
    room_ids = current_user.user_rooms.pluck(:room_id)
    @room = UserRoom.find_by(user_id: params[:followee_id], room_id: room_ids)
    if @room.blank?
      @room = Room.create!
      current_user.user_rooms.create!(room_id: @room.id)
      @room = UserRoom.create!(user_id: params[:followee_id], room_id: @room.id)
    end
    redirect_to room_path(@room.room_id, user_id: params[:followee_id])
  end

  def show
    @rooms = current_user.room_list
    @room = UserRoom.find_by!(room_id: params[:id], user_id: params[:user_id])
    @messages = Message.includes(:user).where(room_id: params[:id])
    @message = current_user.messages.new
  end
end
