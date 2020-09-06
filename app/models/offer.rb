class Offer < ApplicationRecord
  validates :advertiser_name, :url, :description,:starts_at, presence: true
  validates :advertiser_name, uniqueness: true
  validates_format_of :url, with: URI.regexp
  validates_length_of :description, maximum: 500

  def status
    if ! enable_flag
      return 'disabled'
    end

    if starts_at <= DateTime.now && ends_at.nil?
      return 'enabled'
    end

    if starts_at <= DateTime.now && DateTime.now <= ends_at
      return 'enabled'
    end

    'disabled'
  end
end
