class PostsController < ApplicationController
  impressionist :actions=> [:show]
  
  def show
    @post = Post.find_by(public_uid: params[:id])
    impressionist(@post, nil)
    @page_views = @post.impressionist_count
  end
  
  def latest
    @posts = Post.all.order(created_at: 'DESC').page(params[:page]).per(12)
  end
  
  def view
    @posts = Post.order(impressions_count: 'DESC').page(params[:page]).per(12)
  end
  
  def tags
    if params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").page(params[:page]).per(12)
    end
  end
  
  def search
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      redirect_to controller: 'posts', action: 'show', id: @post.public_uid
    else
      render 'new'
    end
  end
  
  private
  def post_params
    params.require(:post).permit(:title, :name, :overview, :label1, :label2, :label3, :label4, :label5, :value1, :value2, :value3, :value4, :value5, :bgcolor, :tag_list)
  end
  
  def search_params
    params.require(:q).permit!
  end
end

