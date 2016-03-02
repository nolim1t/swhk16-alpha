class HomeController < ActionController::Base
 	layout 'application'

	def index
	end

  def new
  end

  def contact_careers
  end

  def faq
  end

  def legal
    
  end
  
  def showexperts
    @experts = User.where(:expert_contact_info => {:$exists => true}, :expert_location_info => {:$exists => true}, :coordinates => {:$exists => true}, :expert_is_available => true).paginate(:page => params[:page], :per_page => 6)
  end
end
