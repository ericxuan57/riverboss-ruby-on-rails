class SuggestController < ApplicationController

  def new; end

  def create
    @suggest = Suggest.new(params[:suggest])
    @suggest.request = request
    if @suggest.deliver
      redirect_to root_path, notice: "We have recieved you suggestion, Thank you."
    else
      flash[:alert] = "Something went wrong, please try again."
      render 'new'
    end
  end

end