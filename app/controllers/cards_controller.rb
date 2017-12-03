class CardsController < ApplicationController
  # POST /cards
  def create
    @card = account.create_card!(card_params)
    render json: @card, status: :created
  rescue => e
    puts e.inspect
    render json: nil, status: :unprocessable_entity
  end

  private
    # Only allow a trusted parameter "white list" through.
    def card_params
      params.require(:card).permit(:digits, :valid_thru)
    end
end
