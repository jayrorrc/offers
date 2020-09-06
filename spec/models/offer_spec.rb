require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject { described_class.new(
    advertiser_name: "Company example",
    url: "http://www.example.com",
    description: "Description example",
    starts_at: DateTime.now.yesterday
  )}


  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:advertiser_name) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:starts_at) }
    it { should validate_uniqueness_of(:advertiser_name) }

    it do
      should allow_values('http://foo.com', 'https://bar.com').for(:url)
    end

    it do
      should_not allow_values('foo', 'buz').for(:url)
    end

    it {should validate_length_of(:description).is_at_most(500)}
  end

  it "disebled on create" do
    subject.status.should eq('disabled')
  end

  it "enabled if current time >= starts_at" do
    subject.enable_flag = true

    subject.status.should eq('enabled')
  end

  it "disabled if current time >= ends_at" do
    subject.enable_flag = true
    subject.ends_at = DateTime.now - 1.hours

    subject.status.should eq('disabled')
  end

  it "enabled if ends_at is not exists" do
    subject.enable_flag = true
    subject.ends_at = nil

    subject.status.should eq('enabled')
  end

  it "disable if enable_flag is false" do
    subject.enable_flag = false
    subject.ends_at = DateTime.now + 2.months

    subject.status.should eq('disabled')
  end
end
