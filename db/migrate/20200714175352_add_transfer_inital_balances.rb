class AddTransferInitalBalances < ActiveRecord::Migration[5.2]
  def change
    add_column :transfers, :initial_source_balance, :integer
    add_column :transfers, :initial_destination_balance, :integer
    add_column :transfers, :final_source_balance, :integer
    add_column :transfers, :final_destination_balance, :integer
  end
end
