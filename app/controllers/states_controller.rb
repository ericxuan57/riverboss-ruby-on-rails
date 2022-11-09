class StatesController < ApplicationController

  def index
    @states = State.for_menu
  end

  def show
    state = Array(State.where("slug = '#{params[:id]}'"))
    state_id = 0
    state.each do |r|
      state_id = r.id
    end
    @state = State.find(state_id)
    @rivers = @state.rivers.sort_by_short_name.page(params[:page])
  end

end
