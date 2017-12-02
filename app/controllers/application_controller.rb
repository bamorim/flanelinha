class ApplicationController < ActionController::API
  def account
    Account.first
  end
end
