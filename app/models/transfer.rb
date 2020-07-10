class Transfer < ApplicationRecord
  belongs_to :source, class_name: 'Account', foreign_key: "source_id"
  belongs_to :destination, class_name: 'Account', foreign_key: "destination_id"

  validates :source, presence: true
  validates :destination, presence: true
  validates :amount, presence: true, numericality: true

  has_many :transactions, as: :reason
  include AASM

  aasm column: 'state' do
    state :request, initial: true
    state :done
    state :failed

    event :complete do
      transitions to: :done
    end

    event :fail do
      transitions to: :failed
    end
  end
  
  def process_money
    return unless valid?

    if self.source.balance < self.amount
      fail!
      return
    end  

    Transaction.create(account: self.source, amount: -self.amount, reason: self)
    Transaction.create(account: self.destination, amount: self.amount, reason: self)

    complete!
  end
end
