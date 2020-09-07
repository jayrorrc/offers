require 'rails_helper'

RSpec.describe OffersController, type: :request do
  describe "GET #index" do
    it "this return all offers" do
      offers = FactoryBot.create_list(:offer, 10)

      get offers_path
      expect(assigns(:offers)).to match_array(offers)
    end

    it "renders the index template" do
      get offers_path
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "creating a offer" do
      get new_offer_path
      expect(response).to render_template(:new)

      offer = FactoryBot.json(:offer)

      post offers_path, :params => {
        :offer => {
          :advertiser_name => 'Company Name',
          :url => 'http://foo.com',
          :description => 'Description',
          :starts_at => DateTime.now
        }
      }

      expect(response).to redirect_to(offers_path)
      assigns(:offer).status.should eq('disabled')

      follow_redirect!

      expect(response).to render_template(:index)
    end

    it "creating a invalid offer" do
      get new_offer_path
      expect(response).to render_template(:new)

      offer = FactoryBot.json(:offer)

      post offers_path, :params => {
        :offer => {
          :advertiser_name => 'Company Name',
          :url => 'foo',
          :description => 'Description',
          :starts_at => DateTime.now
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end

    it "renders the index template" do
      get new_offer_path
      expect(response).to render_template(:new)
      expect(response).to_not render_template(:show)
    end
  end

  describe "GET #edit" do
    it "editing a offer" do
      offer = FactoryBot.create(:offer)

      get edit_offer_path(offer)

      expect(assigns(:offer)).to eq(offer)
      expect(response).to render_template(:edit)

      offer.advertiser_name = "Another Name"

      patch offer_path, :params => { :offer => JSON.parse(offer.to_json) }
      expect(response).to redirect_to(offers_path)

      follow_redirect!

      expect(response).to render_template(:index)
    end
  end

  describe "POST #toggle_status" do
    it "disable a offer" do
      offer = FactoryBot.create(:offer_enabled)

      post toggle_status_path(offer)

      expect(assigns(:offer)).to eq(offer)
      assigns(:offer).status.should eq('disabled')

      expect(response).to redirect_to(offers_path)
      follow_redirect!

      expect(response).to render_template(:index)
    end

    it "enable a offer" do
      offer = FactoryBot.create(:offer)

      post toggle_status_path(offer)

      expect(assigns(:offer)).to eq(offer)
      assigns(:offer).status.should eq('enabled')

      expect(response).to redirect_to(offers_path)
      follow_redirect!

      expect(response).to render_template(:index)
    end
  end

  describe "DELETE #destroy" do
    it "detroy a offer" do
      offers = FactoryBot.create_list(:offer, 10)
      number_offers = offers.count

      offer = offers.shift
      delete offer_path(offer)
      expect(assigns(:offer)).to eq(offer)

      expect(response).to redirect_to(offers_path)
      follow_redirect!

      expect(response).to render_template(:index)

      expect(assigns(:offers)).to match_array(offers)
      expect(assigns(:offers).count).to eq(number_offers -1)
    end
  end

  describe "GET #dashboard" do
    it "must to be enabled offers with the premiuns first" do
      offers = FactoryBot.create_list(:offer_enabled, 10)
      offers_premium = FactoryBot.create_list(:offer_enabled_premium, 10)

      number_offers = offers.count + offers_premium.count

      get root_path
      expect(assigns(:offers)).to eq(offers_premium.concat(offers))
      expect(assigns(:offers).count).to eq(number_offers)

      expect(response).to render_template(:dashboard)

    end
  end
end
