class AddTransferUuid < ActiveRecord::Migration[5.2]
  def change
    add_column :transfers, :transfer_uuid, :string
  end
end
