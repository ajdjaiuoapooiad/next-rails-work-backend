class Api::V1::MessagesController < ApplicationController
  before_action :authorize_request

  def index
    @messages = Message.where(sender_id: current_user.id).or(Message.where(receiver_id: current_user.id))
    render json: @messages
  end

  def show
    # conversationIdは送信者と受信者のidをハイフンで繋げたものです。
    sender_id, receiver_id = params[:id].split('-').map(&:to_i)

    # ユーザーが会話に参加しているか確認します。
    unless [sender_id, receiver_id].include?(current_user.id)
      render json: { error: "許可されていません" }, status: :forbidden
      return
    end

    @messages = Message.where(
      "(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
      sender_id, receiver_id, receiver_id, sender_id
    ).order(created_at: :asc)

    render json: @messages
  end

  def create
    @message = Message.new(message_params)
    @message.sender = current_user
    if @message.save
      render json: @message, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.permit(:receiver_id, :content)
  end
end