class MobileController < ApplicationController

  def switch_to_mobile
    cookies[:view] = :mobile
    redirect_to root_path
  end

  def switch_to_html
    cookies[:view] = :html
    redirect_to root_path
  end

end