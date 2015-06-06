class StaticPagesController < ApplicationController

  def home
  end

  def about
  end

  def contact
  end

  def help
  	
  
  
  headshot_photo = HeadshotPhoto.last
  @headshot_photo_patch = headshot_custom_image_url(headshot_photo.image_file_name)
  headshot_patch = headshot_custom_file_path(headshot_photo.image_file_name)
  @avatar_path = avatar_file_path(@user.avatar.to_s[0..48])
  auth = face_recognition( headshot_patch , @avatar_path).to_f
  

    
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

