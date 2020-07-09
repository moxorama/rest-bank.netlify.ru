class Transfer < ApplicationRecord
  belongs_to :source, class_name: Account
  belongs_to :destination, class_name: Account

  validates :source, presence: true
  validates :destination, presence: true
  validates :amount, presence: true, numericality: true

  has_many :transactions, as: :reason

  include AASM do
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

    if @source.amount < @amount
      @fail!
      return
    end  

    Transaction.create(account: @source, amount: -@amount, reason: self)
    Transaction.create(account: @destination, amount: @amount, reason: self)

    @complete!
  end
end
