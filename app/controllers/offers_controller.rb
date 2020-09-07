class OffersController < ApplicationController
  def index
    @offers = Offer.all
  end

  def new
    @offer = Offer.new
  end

  def show
    @offer = Offer.find(params[:id])
  end

  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      redirect_to offers_path
    else
      render 'new'
    end
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def update
    @offer = Offer.find(params[:id])

    if @offer.update(offer_params)
      redirect_to offers_path
    else
      render 'edit'
    end
  end

  def destroy
    @offer = Offer.find(params[:id])
    @offer.destroy

    redirect_to offers_path
  end

  def toggle_status
    @offer = Offer.find(params[:id])
    @offer.enable_flag = !@offer.enable_flag
    @offer.save

    redirect_to offers_path
  end

  def dashboard
    @offers = Offer.order(premium: :desc).select { |offer| offer.status == 'enabled'}
  end

  private
    def offer_params
      params.require(:offer).permit(
        :advertiser_name,
        :url,
        :description,
        :starts_at,
        :ends_at,
        :premium
      )
    end
end
