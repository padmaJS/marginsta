class ChatChannel < ApplicationCable::Channel
  def subscribed
    @chat = Chat.find(params[:id])
    stream_from "chat_#{@chat.id}"
    key = "chat_#{@chat.id}_users"
    $redis.sadd(key, current_user.id)

    broadcast_user_online(true)

    send_current_state(key)
  end

  def unsubscribed
    broadcast_user_online(false)
  end

  def receive(data)
    case data["action"]
    when "typing_start"
      broadcast_typing(true)
    when "typing_stop"
      broadcast_typing(false)
      # when "send_message"
      # Handle message creation if needed
    else
      puts "Unknown action: #{data["action"]}"
    end
  end

  def typing_start
    broadcast_typing(true)
  end

  def typing_stop
    broadcast_typing(false)
  end

  private

  def broadcast_user_online(online)
    ActionCable.server.broadcast("chat_#{@chat.id}", {
      action: "user_online",
      user_id: current_user.id,
      online: online
    })
  end

  def broadcast_typing(typing)
    ActionCable.server.broadcast("chat_#{@chat.id}", {
      action: "typing",
      user_id: current_user.id,
      typing: typing
    })
  end

  def send_current_state(key)
    online_users = $redis.smembers(key)

    online_users.each do |user_id|
      id = user_id.to_i

      unless id == current_user.id
        transmit({action: "user_online", user_id: id, online: true})
      end
    end
  end
end
