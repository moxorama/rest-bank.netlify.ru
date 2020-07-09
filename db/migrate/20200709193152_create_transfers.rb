class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.references :source
      t.references :destination
      t.string :state
      t.decimal :amount
      t.timestamps
    end

    add_index :transfers, :state
  end
end
