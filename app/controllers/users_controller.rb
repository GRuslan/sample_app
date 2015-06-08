class UsersController < ApplicationController
  helper :headshot
  before_action :signed_in_user, only: [:edit, :update]
  def show
    @user = User.find(params[:id])
    l = @user.avatar.to_s.length
    @avatar_path = avatar_file_path(@user.avatar.to_s[0..l-12])
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
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

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
end