class Admin::RiversController < ApplicationController

  before_filter :authenticate_admin!

  def index
    @rivers = River.page(params[:page])
  end

  def search
    @rivers = River.order(:name).where("name ILIKE ?", "%#{params[:q]}%").page(params[:page])
    render action: :index
  end

  def edit
    @river = River.find params[:id]
  end

  def update
    @river = River.find params[:id]
    @river.conditions = params[:river][:conditions]
    if @river.save
      redirect_to admin_rivers_path, notice: 'River conditions was successfully updated.'
    else
      render action: 'edit', alert: "Something went wrong, please try again!"
    end
  end

end
