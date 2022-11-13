class UsersRiversController < ApplicationController

  before_action :authenticate_user

  def index
    @users_rivers = current_user.users_rivers.includes(:river)
    redirect_to new_users_river_path unless @users_rivers.any?
  end

  def create
    @user_river = UsersRiver.new(user_id: current_user.id, river_id: params[:river_id])
    if @user_river.save
      respond_to do |format|
        format.html {
          flash[:notice] = "#{@user_river.river.name} has been added to My Rivers."
          redirect_to users_rivers_path
        }
        format.json {
          render json: {status: 'success', url: edit_users_river_path(@user_river.river)}
        }
        format.mobile {
          flash[:notice] = "#{@user_river.river.name} has been added to My Rivers."
          redirect_to users_rivers_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = check_duplicate_msg ? @user_river.errors.messages[:river_id][0] : "We couldn't add #{@user_river.river.name} to My Rivers, please try again."
          redirect_to users_rivers_path and return if check_duplicate_msg
          render 'new'
        }
        format.json {
          render json: {status: 'failure'}
        }
        format.mobile {
          flash[:error] = check_duplicate_msg ? @user_river.errors.messages[:river_id][0] : "We couldn't add #{@user_river.river.name} to My Rivers, please try again."
          redirect_to users_rivers_path and return if check_duplicate_msg
          render 'new'
        }
      end
    end
  end

  def sort
    @users_rivers = current_user.users_rivers
    @users_rivers.each do |ur|
      ur.position = params['users_river'].index(ur.id.to_s) + 1
      ur.save
    end
    render nothing: true
  end

  def destroy
    @user_river = current_user.users_rivers.find(params[:id])
    if @user_river.destroy!
      flash[:notice] = "#{@user_river.river.name} has been deleted from My Rivers."
      redirect_to users_rivers_path
    else
      flash[:error] = "We couldn't add #{@user_river.river.name} to My Rivers, please try again."
      render 'new'
    end
  end

  def edit
    # Caution - Sending River ID here not UserRiver ID
    river = River.find(params[:id])
    if current_user.rivers.pluck(:id).include? river.id
      user_river = current_user.users_rivers.find_by_river_id(river.id)
      result = render_to_string "shared/_users_river_condition", layout: false, locals: {river: river, user_river: user_river}
    else
      result = render_to_string "shared/_users_river_form", layout: false, locals: {river: river}
    end
    respond_to do |format|
      format.html
      format.json {
        render json: {result: result}
      }
      format.mobile {
        render json: {result: result}
      }
    end
  end

  def update
    @user_river = current_user.users_rivers.find params[:id]
    if params[:default] == "true"
      @user_river.conditions = @user_river.river.conditions
    else
      @user_river.conditions = {low: params[:user_river][:condition_low], high: params[:user_river][:condition_high]}
    end
    @user_river.save
    redirect_to params[:redirect_to] || users_rivers_path
  end

  private

  def check_duplicate_msg
    @user_river.errors.messages[:river_id][0] == "This river is already present in your My Rivers." ? true : false
  end

end
