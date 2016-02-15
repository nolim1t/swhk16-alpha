class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end
  def create
    super
    @accounttype = params[:accounttype]
  end
  def update
    super
  end
  def sign_up(resource_name, resource)
    # resource is savable
    puts "SIGNUP (before modification):\nResource name: #{resource_name}\nResource: #{resource.inspect} "
    # Lets change the values below with our custom fields
    resource.timezone = "Asia/Hong_Kong"
    if params[:accounttype] != nil then
      if params[:accounttype] == "vendor" or params[:accounttype] == "standard" then
        resource.accounttype = params[:accounttype]
      end
    end
    # Begin: invite codes
    if params[:user][:invite_code] != nil then
      find_invite_code = Invitecode.where(code: params[:user][:invite_code].to_s)
      if find_invite_code.length == 1 then
        # Check postprocess_instructions
        if find_invite_code[0]['postprocess_instructions'] == "email" then
          # If email, check email and then assign cards to this
          if params[:user][:email] == find_invite_code[0]['email'] then
            puts "Assign cards to userid #{resource._id} which have email #{find_invite_code[0]['email']}"
          else
            puts "No need to assign anything"
          end
        end
        # Remove invite code when done with it
        puts find_invite_code.destroy
      end
    end
    # End: invite codes
    resource.identity_verified = "false"
    resource.save

    # Continue the process
    super
  end

  def sign_up_params
     params.require(:user).permit(:email, :password, :password_confirmation, :name, :invite_code, :accounttype)
  end
  def account_update_params
     params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
  end
end
