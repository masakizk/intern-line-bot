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

          if user_message.include?("アドバイス")
            # メッセージに「アドバイス」が含まれている場合は、健康に関する簡単なアドバイスを答える
            advice_response(client, event)
          else
            # 話しかけると、飯テロ画像を送信する。
            food_response(client, event)
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

  private

  # LINE BOTでテキストを送信するためのオブジェクトを作成する
  def create_text_object(message)
    {
      type: 'text',
      text: message
    }
  end

  # LINE BOTで画像を送信するためのオブジェクトを作成する
  def create_image_object(image_url)
    {
      type: "image",
      originalContentUrl: image_url,
      previewImageUrl: image_url
    }
  end

  # ランダムに選ばれたご飯の画像を送信する
  def food_response(client, event)
    message = create_text_object("これでも食べな")

    # ランダムにご飯の画像を一枚選ぶ
    food_images = %w[food_ramen.jpg food_hamburg.jpg food_oden.jpg]
    selected_food_image = food_images.sample

    food_image_url = "https://#{ENV["HOST_NAME"]}/assets/#{selected_food_image}"
    image = create_image_object(food_image_url)

    client.reply_message(event['replyToken'], [message, image])
  end

  # 健康に関するアドバイスを返す
  def advice_response(client, event)
    advices = Advice.all
    selected_advice = advices.sample

    messages = [
      create_text_object("仕方ないなぁ。　一つ、伝授しようではないか"),
      create_text_object(selected_advice.message)
    ]

    client.reply_message(event['replyToken'], messages)
  end
end
