# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  delegate :user_name, to: :user, allow_nil: true
end
