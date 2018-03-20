require "administrate/base_dashboard"

class OrderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    order_items: Field::HasMany,
    user: Field::BelongsTo,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    credit_card_number: Field::String,
    credit_card_expiry: Field::DateTime,
    credit_card_cvc: Field::String,
    credit_card_name: Field::String,
    credit_card_type: Field::String,
    total_amount: Field::Number.with_options(decimals: 2),
    status: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :order_items,
    :user,
    :id,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :order_items,
    :user,
    :id,
    :created_at,
    :updated_at,
    :credit_card_number,
    :credit_card_expiry,
    :credit_card_cvc,
    :credit_card_name,
    :credit_card_type,
    :total_amount,
    :status,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :order_items,
    :user,
    :credit_card_number,
    :credit_card_expiry,
    :credit_card_cvc,
    :credit_card_name,
    :credit_card_type,
    :total_amount,
    :status,
  ].freeze

  # Overwrite this method to customize how orders are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(order)
  #   "Order ##{order.id}"
  # end
end
