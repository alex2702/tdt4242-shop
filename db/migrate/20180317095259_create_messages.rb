class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.string :subject
      t.string :body
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
