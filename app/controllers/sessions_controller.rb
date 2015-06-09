class SessionsController < ApplicationController
   helper :headshot
  def new
     
  end

  def create
    sleep 0.5
    user = User.find_by(email: params[:session][:email].downcase)
    l = user.avatar.to_s.length
    @avatar_path = avatar_file_path(user.avatar.to_s[0..l-12])
    headshot_photo = HeadshotPhoto.last
    headshot_patch = headshot_custom_file_path(headshot_photo.image_file_name)
    @auth = face_recognition( headshot_patch , @avatar_path).to_f

    if user && user.authenticate(params[:session][:password]) && @auth > 0.99
      sign_in user
      redirect_to user

    elsif user && user.authenticate(params[:session][:password]) && @auth < 0.99
      flash.now[:error] = ' Ви не прошли автентифікацію по обличчю! ' # Not quite right!
      render 'new'
    else
      flash.now[:error] = 'Invalid email/password combination ' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end


  protect_from_forgery

def headshot_custom_file_path(file_name)
File.join(Rails.root, 'public', 'headshots', file_name)
end

def avatar_file_path(file_name)
File.join(Rails.root, 'public', file_name)
end

def headshot_custom_image_url(file_name)
'http://' + request.host_with_port + '/headshots/' + file_name
end

   def face_recognition(savedFoto, newFoto)
     i = `br -algorithm FaceRecognition -compare "#{savedFoto}" "#{newFoto}"`
   end
  

  
end
