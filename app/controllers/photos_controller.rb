class PhotosController < ApplicationController

  def index
    @photos = Photo.all
  end
  
  def show
    @photo =Photo.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def edit
    @photo = Photo.find_by_id(params[:id])
  end

  def create
    @photo = Photo.new(params_photo)
    @photo.save
    flash[:notice] = "Success Add Records"
    redirect_to action: 'index'
  end

  def update
     @photo = Photo.find_by_id(params[:id])
     if @photo.update(params_photo)
        flash[:notice] = "Success Update Records"
        redirect_to action: 'index'
     else
        flash[:error] = "data not valid"
        render 'edit'
     end
  end

def photo
  
end

  def destroy
    @photo = Photo.find_by_id(params[:id])
    if @photo.destroy
        flash[:notice] = "Success Delete a Records"
        redirect_to action: 'index'
    else
        flash[:error] = "fails delete a records"
        redirect_to action: 'index'
    end
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def params_photo
      params.require(:photo).permit(:title, :image, :photo)
    end
end
