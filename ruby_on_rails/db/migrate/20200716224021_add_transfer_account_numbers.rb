class AddTransferAccountNumbers < ActiveRecord::Migration[5.2]
  def change
    add_column :transfers, :source_account_number, :string
    add_column :transfers, :destination_account_number, :string
  end

end
