# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :followee_id, null: false, foreign_key: true

      t.timestamps
    end
    add_index :follows, %i[user_id followee_id], unique: true
  end
end
