class TransferController < ActionController::Base
  before_action :authenticate_user!
  def outbound
  end

  def inbound
  end
end
