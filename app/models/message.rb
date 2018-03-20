class Message < ApplicationRecord
  belongs_to :order
  scope :created_at_desc, -> { order(created_at: :desc) }
end