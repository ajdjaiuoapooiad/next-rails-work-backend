# app/controllers/api/v1/profiles_controller.rb
class Api::V1::ProfilesController < ApplicationController
  before_action :authorize_request
  before_action :set_profile, only: [:show, :update]

  def show
    render json: @profile.as_json(include: [:user_icon, :bg_image])
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      attach_images
      render json: @profile.as_json(include: [:user_icon, :bg_image]), status: :created
    else
      render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @profile.update(profile_params)
      attach_images
      render json: @profile.as_json(include: [:user_icon, :bg_image])
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

  def attach_images
    if params[:user_icon]
      @profile.user_icon.attach(params[:user_icon])
    end
    if params[:bg_image]
      @profile.bg_image.attach(params[:bg_image])
    end
  end
end