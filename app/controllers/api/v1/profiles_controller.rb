# app/controllers/api/v1/profiles_controller.rb
class Api::V1::ProfilesController < ApplicationController
  before_action :authorize_request
  before_action :set_profile, only: [:show, :update]

  def show
    user_icon_url = @profile.user_icon.attached? ? url_for(@profile.user_icon) : nil
    bg_image_url = @profile.bg_image.attached? ? url_for(@profile.bg_image) : nil

    render json: @profile.as_json.merge(user_icon_url: user_icon_url, bg_image_url: bg_image_url)
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      if params[:user_icon]
        @profile.user_icon.attach(params[:user_icon])
      end
      if params[:bg_image]
        @profile.bg_image.attach(params[:bg_image])
      end
      user_icon_url = @profile.user_icon.attached? ? url_for(@profile.user_icon) : nil
      bg_image_url = @profile.bg_image.attached? ? url_for(@profile.bg_image) : nil

      render json: @profile.as_json.merge(user_icon_url: user_icon_url, bg_image_url: bg_image_url), status: :created
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @profile.update(profile_params)
      if params[:user_icon]
        @profile.user_icon.attach(params[:user_icon])
      end
      if params[:bg_image]
        @profile.bg_image.attach(params[:bg_image])
      end
      user_icon_url = @profile.user_icon.attached? ? url_for(@profile.user_icon) : nil
      bg_image_url = @profile.bg_image.attached? ? url_for(@profile.bg_image) : nil

      render json: @profile.as_json.merge(user_icon_url: user_icon_url, bg_image_url: bg_image_url)
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.permit(:introduction, :skills, :company_name, :industry)
  end

  def set_profile
    @profile = current_user.profile
  end
end