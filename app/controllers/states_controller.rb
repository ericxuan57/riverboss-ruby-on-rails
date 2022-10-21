class StatesController < ApplicationController

  def index
    @states = State.for_menu
  end

  def show
    @state = State.find(params[:id])
    @rivers = @state.rivers.sort_by_short_name.page(params[:page])
  end

end