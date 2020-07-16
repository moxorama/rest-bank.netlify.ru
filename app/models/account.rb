class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :account_number, uniqueness: true

  def withdraw(amount)
    with_lock { update!(balance: balance - amount) }
  end

  def deposit(amount)
    with_lock { update!(balance: balance + amount) }
  end
end
