class Transfer < ApplicationRecord
  belongs_to :source, class_name: 'Account', foreign_key: "source_id"
  belongs_to :destination, class_name: 'Account', foreign_key: "destination_id"

  validates :source, presence: true
  validates :destination, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_create :save_initial_balances

  has_many :transactions, as: :reason
  include AASM

  aasm column: 'state' do
    state :request, initial: true
    state :done
    state :concurrency
    state :no_balance

    event :complete do
      transitions to: :done
    end

    event :concurrency do
      transitions to: :concurrency
    end

    event :no_balance do
      transitions to: :no_balance
    end
  end

  
  def process_money
    return unless valid?

    if self.source.balance <= self.amount
      no_balance!
      return
    end 

    # Для решения проблем concurrency при изменении баланса используем optimistic lock
    # https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html
    # Если по каким-то причинам баланс аккаунта поменялся - откатываем транзакцию 
    Account.transaction do
      begin
        source.update_attributes(balance: source.balance - self.amount)
        destination.update_attributes(balance: destination.balance + self.amount)

        Transaction.create(account: self.source, amount: -self.amount, reason: self)
        Transaction.create(account: self.destination, amount: self.amount, reason: self)

        self.update_attributes(
          final_source_balance: source.balance,
          final_destination_balance: destination.balance
        )
        complete!
      rescue
        concurrency!
      end
    end
  end


  def save_initial_balances
    self.initial_source_balance = self.source.balance
    self.initial_destination_balance = self.destination.balance
  end
end
