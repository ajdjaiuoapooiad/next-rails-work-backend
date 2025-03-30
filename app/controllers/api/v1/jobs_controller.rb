# app/controllers/api/v1/jobs_controller.rb
class Api::V1::JobsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :set_job, only: [:show, :update, :destroy]
  before_action :require_company, only: [:create, :update, :destroy] # 企業ユーザーのみ許可

  def index
    @jobs = Job.all.map do |job|
      job.as_json.merge(image_url: job.image.attached? ? url_for(job.image) : nil)
    end
    render json: @jobs
  end

  def show
    render json: @job.as_json.merge(image_url: @job.image.attached? ? url_for(@job.image) : nil)
  end

  def create
    @job = current_user.jobs.build(job_params) # current_userは企業ユーザー
    if @job.save
      if params[:image]
        @job.image.attach(params[:image])
      end
      render json: @job.as_json.merge(image_url: @job.image.attached? ? url_for(@job.image) : nil), status: :created
    else
      render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      if params[:image]
        @job.image.attach(params[:image])
      end
      render json: @job.as_json.merge(image_url: @job.image.attached? ? url_for(@job.image) : nil)
    else
      render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    head :no_content
  end

  private

  def job_params
    params.permit(:title, :description, :location, :salary, :requirements, :benefits, :employment_type)
  end

  def set_job
    @job = Job.find(params[:id])
  end

  def require_company
    unless current_user.company?
      render json: { error: '権限がありません。企業ユーザーのみ可能です。' }, status: :unauthorized
    end
  end
end