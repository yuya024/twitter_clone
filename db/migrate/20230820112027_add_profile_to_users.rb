# frozen_string_literal: true

class AddProfileToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users, bulk: true do |_t|
      add_column :users, :introduction, :string, limit: 160
      add_column :users, :location, :string, limit: 30
      add_column :users, :website, :string, limit: 100
    end
  end
end
