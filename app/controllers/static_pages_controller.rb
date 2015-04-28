class StaticPagesController < ApplicationController
  def home
  end

  def help
  flash[:success] = face_recognition("/home/ruslan/me.jpg", "/home/ruslan/you.jpg");
  end

  def about
  end

  def contact
  end

  def face_recognition(savedFoto, newFoto)
    i = `br -algorithm FaceRecognition -compare #{savedFoto} #{newFoto}`
  return i
  end
end
