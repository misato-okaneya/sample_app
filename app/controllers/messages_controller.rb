class MessagesController < ApplicationController
  before_action :retrieve_members, only: [:index, :show]


  def new
    @message = ActsAsMessageable::Message.new
    target_id = params[:target_id]
    @target = User.find(target_id)
  end 

  def create
#    if current_user.send_messssage(@)
    target_id = params[:target_id]
    target = User.find(target_id)
    if current_user.messages.are_from(target).blank? && current_user.messages.are_to(target).blank?
      current_user.send_message(target, params[:acts_as_messageable_message][:body])
    else
      message = current_user.messages.are_from(target).first
      message = current_user.messages.are_to(target).first unless message
      current_user.reply_to(message, params[:acts_as_messageable_message][:body])
    end  
    redirect_to root_path
  end

  def users_list
    @users = User.paginate(page: params[:page])
#    user = User.find(params[:id])
  end

  def index
  end

  def show
    @title = "Conversation"
    @member = User.find(params[:id])
    message = current_user.messages.are_from(@member).first
    message = current_user.messages.are_to(@member).first unless message
    @messages = message.conversation
#    render 'show_follow'
  end

  private

  def retrieve_members
    members_id = []
    current_user.sent_messages.each do |received|
      receiver_id = received.received_messageable_id
      members_id << receiver_id
    end
    current_user.received_messages.each do |sent|
      sender_id = sent.sent_messageable_id
      members_id << sender_id
    end
    @members_id_uniq = members_id.uniq
    @members = User.where(id: @members_id_uniq)
  end


end