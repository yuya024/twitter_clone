# frozen_string_literal: true

class RemoveReplyToFromTweets < ActiveRecord::Migration[7.0]
  def change
    remove_column :tweets, :reply_to, :int
  end
end
