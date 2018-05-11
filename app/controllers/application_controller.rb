class ApplicationController < ActionController::API
  def index
    render plain: 'a ok', status: 200
  end
end
