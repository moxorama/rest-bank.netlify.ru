class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :reason_type
      t.string :reason_id
      t.references :account
      t.decimal :amount
      t.string :state
      t.string :transaction_uuid
      t.string :comment
      t.timestamps
    end

    add_index :transactions, :state
  end
end
