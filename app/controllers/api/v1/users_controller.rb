class Api::V1::UsersController < ApplicationController
    before_action :authorize_request, except: [:create, :show_by_id]
    before_action :set_user, only: [:show, :update, :destroy]


  def show_by_id
    @user = User.find_by(id: params[:id])
    if @user
      @profile = @user.profile
      user_icon_url = nil # 初期化

      if @profile&.user_icon&.attached?
        # Active Storageを使用している場合、rails_blob_urlで直接URLを生成
        user_icon_url = rails_blob_url(@profile.user_icon)
      elsif @profile&.user_icon_url # Active Storageを使用していない場合
        # 提供されたJSONデータ構造からURLを抽出
        user_icon_url = @profile.user_icon_url
      end

      render json: {
        id: @user.id,
        name: @user.name,
        user_type: @user.user_type,
        profile: {
          user_icon_url: user_icon_url
        }
      }
    else
      render json: { error: "User with id #{params[:id]} not found" }, status: :not_found
    end
  end


  
    def index
      @users = User.all
      render json: @users
    end
  
    def show
      render json: @user
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        # ユーザーIDをレスポンスに含める
        render json: { user: { id: @user.id } }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @user.destroy
      head :no_content
    end
  
    private
  
    def user_params
      params.permit(:name, :email, :password, :password_confirmation, :user_type)
    end
  
    def set_user
      @user = User.find(params[:id])
    end
end