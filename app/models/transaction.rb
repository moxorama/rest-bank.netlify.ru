class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :reason, polymorphic: true, optional: true

  validates :account, presence: true
  validates :amount, presence: true, numericality: true

  before_validation :generate_transaction_number

  def generate_transaction_number
    if self.transaction_uuid.blank?
      self.transaction_uuid = SecureRandom.uuid
    end
  end
end
