class AddStatusToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :new_status, :string
  end
end
