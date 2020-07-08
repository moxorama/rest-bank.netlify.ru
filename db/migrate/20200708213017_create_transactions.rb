class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :state
      t.string :transaction_type
      t.string :transaction_uuid
      t.string :comment
      t.references :account
      t.timestamps
    end

    add_index :transactions, :account_id
    add_index :transactions, :transaction_type
    add_index :transactions, :state
  end
end
