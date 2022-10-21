class Admin::StatesController < ApplicationController

  before_filter :authenticate_admin!

  def index
    @states = State.all
  end

end
