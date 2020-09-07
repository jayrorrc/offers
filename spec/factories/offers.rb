FactoryBot.define do
  factory :offer do
    sequence(:advertiser_name) {|n| "Company - #{n}"}
    sequence(:url) {|n| "http://foo#{n}.com" }
    sequence(:description) {|n| "Description - #{n}"}
    starts_at { DateTime.now }
  end

  factory :offer_enabled, class: "Offer" do
    sequence(:advertiser_name) {|n| "Company Enabled - #{n}"}
    sequence(:url) {|n| "http://foo#{n}.com" }
    sequence(:description) {|n| "Description - #{n}"}
    starts_at { DateTime.now }
    enable_flag {true}
  end

  factory :offer_enabled_premium, class: "Offer" do
    sequence(:advertiser_name) {|n| "Company Enabled Premium - #{n}"}
    sequence(:url) {|n| "http://foo#{n}.com" }
    sequence(:description) {|n| "Description - #{n}"}
    starts_at { DateTime.now }
    enable_flag {true}
    premium {true}
  end
end

class JsonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  delegate :association, to: :@strategy

  def result(evaluation)
    @strategy.result(evaluation).to_json
  end
end

FactoryBot.register_strategy(:json, JsonStrategy)
