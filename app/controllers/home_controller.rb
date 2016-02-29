class HomeController < ActionController::Base
 	layout 'application'

	def index

	end

  def new
  end

  def showexperts
    @experts = User.where(:expert_contact_info => {:$exists => true}, :expert_location_info => {:$exists => true}, :coordinates => {:$exists => true})
  end
end
