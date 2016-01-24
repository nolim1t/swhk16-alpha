class HomeController < ActionController::Base
 	layout 'landing'

	def index

	end

  def login
    username = params['username']
    password = params['password']
    find_user = User.find(:all, :conditions => {:username => username, :password => password})
    logger.info("#{find_user}")
    render :text => "Hi"
  end
end
