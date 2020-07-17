class Account < ApplicationRecord
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :account_number, uniqueness: true

  def withdraw(amount)
    with_lock do 
      update!(balance: balance - amount)
    end
  end

  def deposit(amount)
    with_lock do 
      update!(balance: balance + amount)
    end
  end
end
