class ViewsController < ApplicationController
  before_action :set_link

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path, alert: "This link doesn't exist"
  end

  def show
    @link.views.create(
      ip: request.ip,
      user_agent: request.user_agent
    )
    if @link.url =~ /\Ahttps?:\/\/[\w\-\.]+(\.[\w\-]+)+.*\z/
      redirect_to @link.url, allow_other_host: true
    else
      render plain: "Invalid redirect URL", status: :bad_request
    end
  end
end
