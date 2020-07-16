class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :account_number, uniqueness: true


  after_create :initial_transaction

  def withdraw(amount)
    with_lock { update!(balance: balance - amount) }
  end

  def deposit(amount)
    with_lock { update!(balance: balance + amount) }
  end

  def initial_transaction
    Transaction.create(account: self, amount: self.balance)
  end
end
