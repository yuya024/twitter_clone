# frozen_string_literal: true

class RenameReplayColumnToTweets < ActiveRecord::Migration[7.0]
  def up
    rename_column :tweets, :replay_to, :reply_to
  end

  def down
    rename_column :tweets, :reply_to, :replay_to
  end
end
