class UsersController < ApplicationController
  helper :headshot
  def show
    @user = User.find(params[:id])
    @avatar_path = avatar_file_path(@user.avatar.to_s[0..48])
    headshot_photo = HeadshotPhoto.last
    @headshot_photo_patch = headshot_custom_image_url(headshot_photo.image_file_name)
    headshot_patch = headshot_custom_file_path(headshot_photo.image_file_name)
    @auth = face_recognition( headshot_patch , @avatar_path).to_f
    
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def face 
     headshot_photo = HeadshotPhoto.last
     @path= $avatar_path 
    @headshot_photo_patch = headshot_custom_image_url(headshot_photo.image_file_name)
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation , :avatar )
    end
end