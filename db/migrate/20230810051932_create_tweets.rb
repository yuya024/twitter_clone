# frozen_string_literal: true

class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :content, limit: 140
      t.integer :replay_to

      t.timestamps
    end
  end
end
