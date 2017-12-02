class ApplicationController < ActionController::API
  def account
    account_id && Account.find(account_id)
  end

  def account_id
    params[:account_id]
  end
end
