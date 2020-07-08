class Transaction < ApplicationRecord
  belongs_to :account

  before_validation :load_defaults

  def generate_transcaction_number
    if self.transaction_number.blank?
      self.transaction_number = SecureRandom.uuid
    end
  end
end
