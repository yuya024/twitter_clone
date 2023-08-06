# frozen_string_literal: true

class AddOmniauthToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |_t|
      add_column :users, :provider, :string, null: false, default: ''
      add_column :users, :uid, :string, null: false, default: ''
    end
    add_index :users, %i[uid provider], unique: true
  end
end
