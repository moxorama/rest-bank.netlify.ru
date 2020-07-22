class RemoveOptimisticLock < ActiveRecord::Migration[5.2]
  def change
    remove_column  :accounts, :lock_version
  end
end
