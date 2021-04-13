class MessagesController < ApplicationController
  MAX_DAYS = 30
  MAX_MESSAGES = 100

  def create

    from_user = User.where('username = ?', create_params['from_username']).first
    to_user = User.where('username = ?', create_params['to_username']).first

    if from_user.nil?
      render json: { errors: { from_username: ["Sender does not exist."] } }, status: :unprocessable_entity
      return
    end

    if to_user.nil?
      render json: { errors: { to_username: ["Recipient does not exist."] } }, status: :unprocessable_entity
      return
    end

    message = Message.new(
      content: create_params['content'],
      from_user_id: from_user.id,
      to_user_id: to_user.id,
    )

    if message.save
      render nothing: true, status: :no_content
    else
      render_jsonapi_errors(message)
    end
  end

  def recent_days
    num_days = params[:num_days].to_i
    from_username = params[:from_username]
    to_username = params[:to_username]

    if num_days > MAX_DAYS
      render json: { errors: { num_days: ["Cannot request messages created more than #{MAX_DAYS} days ago."] } }, status: :unprocessable_entity
      return
    end

    from_user = User.where('username = ?', from_username).first
    to_user = User.where('username = ?', to_username).first

    if from_user.nil?
      render json: { errors: { from_username: ["Sender does not exist."] } }, status: :unprocessable_entity
      return
    end

    if to_user.nil?
      render json: { errors: { to_username: ["Recipient does not exist."] } }, status: :unprocessable_entity
      return
    end

    messages = Message
      .where('from_user_id = ?', from_user.id)
      .where('to_user_id = ?', to_user.id)
      .where('created_at >= ?', Time.now - num_days.days)
      .order(created_at: :asc)
      .all

    render jsonapi: messages, status: :ok
  end

  def recent_count
    num_messages = params[:num_messages].to_i
    from_username = params[:from_username]
    to_username = params[:to_username]

    if num_messages > MAX_MESSAGES
      render json: { errors: { num_messages: ["Cannot request more than #{MAX_MESSAGES} messages."] } }, status: :unprocessable_entity
      return
    end

    from_user = User.where('username = ?', from_username).first
    to_user = User.where('username = ?', to_username).first

    if from_user.nil?
      render json: { errors: { from_username: ["Sender does not exist."] } }, status: :unprocessable_entity
      return
    end

    if to_user.nil?
      render json: { errors: { to_username: ["Recipient does not exist."] } }, status: :unprocessable_entity
      return
    end

    messages = Message
      .where('from_user_id = ?', from_user.id)
      .where('to_user_id = ?', to_user.id)
      .order(created_at: :desc)
      .limit(num_messages)
      .all
      .reverse

    render jsonapi: messages, status: :ok
  end

  def recent_everyone_days
    num_days = params[:num_days].to_i

    if num_days > MAX_DAYS
      render json: { errors: { num_days: ["Cannot request messages created more than #{MAX_DAYS} days ago."] } }, status: :unprocessable_entity
      return
    end

    messages = Message
      .where('created_at >= ?', Time.now - num_days.days)
      .order(created_at: :asc)
      .all

    render jsonapi: messages, status: :ok
  end

  def recent_everyone_count
    num_messages = params[:num_messages].to_i

    if num_messages > MAX_MESSAGES
      render json: { errors: { num_messages: ["Cannot request more than #{MAX_MESSAGES} messages."] } }, status: :unprocessable_entity
      return
    end

    messages = Message
      .order(created_at: :desc)
      .limit(num_messages)
      .all
      .reverse

    render jsonapi: messages, status: :ok
  end

  private

    def create_params
      params.require(:message)
            .permit(
              :from_username,
              :to_username,
              :content
            )
    end
end
