class PostsController < ApplicationController
  before_action :authenticate_user!

  # GET /posts
  # GET /posts.json
  def index
    params['name'] =  params['name'].presence || ""
    @tags = Tag.all
    @tag = Tag.find_by_name(params['name'])
    session[:tag_name] = params['name']
    if @tag.blank?
      @tag = Tag.create(name: params['name'])
    end
    from = Time.now - 300
    to = Time.now
    
    @post = Post.new
    @posts = @tag.posts.where(created_at: from..to).includes(user: {image_attachment: :blob})
  end


  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    tag_id = Tag.find_by_name(session[:tag_name]).id
    @post.tag_id = tag_id

    respond_to do |format|
      if @post.save
        broad_params = {}
        broad_params['content'] = @post.content
        broad_params['created'] = l(@post.created_at)
        broad_params['username'] = current_user.username
        broad_params['image'] = current_user.image.attached? ? url_for(current_user.image.variant(gravity: :center, resize:"40x40^", crop:"40x40+0+0").processed) : "/first.png"
        ActionCable.server.broadcast("tag_channel_#{session[:tag_name]}", broad_params)
        format.json { render json: @post , status: :created }
      else
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def post_params
      params["post"]["user_id"] = current_user.id
      params.require(:post).permit(:user_id, :tag_id, :content)
    end
end
