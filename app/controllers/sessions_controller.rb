class SessionsController < ApplicationController
  def create
    acc = Account.where(email: params[:email]).first
    if acc
      render json: acc
    else
      render json: nil, status: :not_found
    end
  end
end
