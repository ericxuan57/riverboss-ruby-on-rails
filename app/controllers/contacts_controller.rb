class ContactsController < ApplicationController

  def new; end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      redirect_to root_path, notice: "We have recieved you message, we will get back to you shortly."
    else
      flash[:alert] = "Something went wrong, please try again."
      render 'new'
    end
  end

end