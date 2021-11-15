require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          user_message = event.message['text']

          if user_message.include?("ご飯")
            # メッセージに「ご飯」が含まれている場合は飯テロ画像を出す
            food_response(client, event)
          else
            echo_response(client, event)
          end

        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    head :ok
  end

  # ランダムに選ばれたご飯の画像を送信する
  def food_response(client, event)
    message = {
      type: 'text',
      text: "これでも食べな"
    }

    # ランダムにご飯の画像を一枚選ぶ
    food_images = %w[food_ramen.jpg food_hamburg.jpg food_oden.jpg]
    selected_food_image = food_images.sample
    food_image_url = "https://#{ENV["HOST_NAME"]}/assets/#{selected_food_image}"
    image = {
      type: "image",
      originalContentUrl: food_image_url,
      previewImageUrl: food_image_url
    }

    client.reply_message(event['replyToken'], [message, image])
  end

  # ユーザーの発言をそのまま返す
  def echo_response(client, event)
    message = {
      type: 'text',
      text: event.message['text']
    }
    client.reply_message(event['replyToken'], message)
  end
end
