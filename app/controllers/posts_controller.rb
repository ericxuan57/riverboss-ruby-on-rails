class PostsController < ApplicationController

  include ApplicationHelper

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_admin!, except: [:show, :index]

  # GET /posts
  def index
    @posts = Post.all.order("created_at DESC").page(params[:page])
    @posts = @posts.where(status: "Published") unless admin_signed_in?
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to posts_path(admin_view: true), notice: 'Post was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /posts/1
  def update
    @post.assign_attributes(post_params)
    @post.slug = nil if @post.title_changed?
    if @post.save
      redirect_to posts_path(admin_view: true), notice: 'Post was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      post = Array(Post.where("slug = '#{params[:id]}'"))
      post_id = 0
      post.each do |r|
        post_id = r.id
      end
      @post = Post.find(post_id)
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :content, :status, :meta_keywords, :meta_description)
    end
end
