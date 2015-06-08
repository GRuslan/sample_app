class SessionsController < ApplicationController
   helper :headshot
  def new
     
  end

  def create
    sleep 0.5
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end


  def face 
    
    redirect_to user
  end
  

  
end
