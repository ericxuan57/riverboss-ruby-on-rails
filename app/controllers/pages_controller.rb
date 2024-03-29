class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_admin!, except: [:show]

  # GET /pages
  def index
    @pages = Page.all
  end

  # GET /pages/1
  def show
  end

  # GET /pages/1/edit
  def edit
  end

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      redirect_to pages_path, notice: 'Page was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      page = Array(Page.where("slug = '#{params[:id]}'"))
      page_id = 0
      page.each do |r|
        page_id = r.id
      end
      @page = Page.find(page_id)
    end

    # Only allow a trusted parameter "white list" through.
    def page_params
      params.require(:page).permit(:title, :content, :status, :meta_keywords, :meta_description)
    end
end
