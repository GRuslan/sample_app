class SessionsController < ApplicationController
   helper :headshot
  def new
     headshot_photo = HeadshotPhoto.last
     @headshot_photo_patch = headshot_custom_image_url(headshot_photo.image_file_name)
     
  end

  def create
   
     user = User.find_by(email: params[:session][:email].downcase)
    l = user.avatar.to_s.length
    @avatar_path = avatar_file_path(user.avatar.to_s[0..l-12])
    headshot_photo = HeadshotPhoto.last
    headshot_patch = headshot_custom_file_path(headshot_photo.image_file_name)
    @auth = face_recognition( headshot_patch , @avatar_path).to_f

    if user && user.authenticate(params[:session][:password]) && @auth > 0.99
      sign_in user
      flash[:success] = ' Ви успішно автентифікувались!'
      redirect_to user

    elsif user && user.authenticate(params[:session][:password]) && @auth < 0.99
      flash[:error] = ' Ви не прошли автентифікацію по обличчю! ' # Not quite right!
      redirect_to face_url
    else
      flash.now[:error] = 'Invalid email/password combination ' # Not quite right!
      render 'new'
    end
  end

  def face
     
     
   end

  def destroy
    sign_out
    redirect_to root_url
  end



  

end
