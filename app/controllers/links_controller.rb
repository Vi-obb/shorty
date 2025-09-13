class LinksController < ApplicationController
  before_action :set_link, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!
  def index
    @links = current_user.links.recent_first
    @link ||= current_user.links.build
  end

  def show
  end

  def create
    @link = current_user.links.build(link_params)
    if @link.save
      respond_to do | format |
        format.html { redirect_to root_path }
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("links", @link)
      }
      end
    else
      index
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @link.update(link_params)
      redirect_to @link
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @link.destroy
    redirect_to root_path, notice: "Link has been deleted"
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
