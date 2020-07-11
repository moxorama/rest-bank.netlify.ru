class AddAccountLock < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :lock_version, :integer, default: 0
  end
end
