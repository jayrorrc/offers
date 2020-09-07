class Offer < ApplicationRecord
  validates :advertiser_name, :url, :description, :starts_at, presence: true
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

  def timeToEnd
    if ends_at.nil?
      return 'Undefined'
    end

    time = ((ends_at.to_time - DateTime.now.to_time) / 86400).to_i

    if time > 1

      time = time.to_i

      if time == 1
        return '1 day'
      end

      return time.to_s + ' days'
    end

    'Less than 24 hours'
  end

  def porcent
    if ends_at.nil?
      return 'Undefined'
    end

    (((DateTime.now.to_time - starts_at.to_time) / (ends_at.to_time - starts_at.to_time)) * 100).to_i
  end
end
