class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy

  validates :balance, presence: true, numericality: true

  after_create :initial_transaction


  def initial_transaction
    Transaction.create(account: self, amount: self.balance)
  end
end
