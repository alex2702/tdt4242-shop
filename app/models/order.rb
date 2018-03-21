class Order < ApplicationRecord
  has_many :order_items
  has_many :messages
  accepts_nested_attributes_for :order_items
  belongs_to :user
  scope :created_at_desc, -> { order(created_at: :desc) }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  # validate cc number as 8 to 19 digits (according to IIN standard)
  validates :credit_card_number, presence: true, length: { minimum: 8, maximum: 19 }, numericality: true
  validates :credit_card_name, presence: true, length: { minimum: 3 }
  validates :credit_card_type, presence: true
  validates :credit_card_cvc, presence: true, length: { is: 3 }, numericality: true
  validates :credit_card_expiry, presence: true
  validate :order_items_present
  validate :expiry_date_in_future

  private

  def order_items_present
    errors.add(:order_items, " – There must be at least one product in the order.") unless
        order_items.count >= 1
  end

  def expiry_date_in_future
    if credit_card_expiry.present? && credit_card_expiry < Date.today.at_beginning_of_month
      errors.add(:credit_card_expiry, "can't be in the past")
    end
  end
end
