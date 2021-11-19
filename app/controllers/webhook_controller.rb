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

          if user_message.include?("天気")
            # メッセージに「天気」が含まれている場合は、今日の天気と、おすすめの運動を提案する
            weather_response(client, event)
          elsif user_message.include?("アドバイス")
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

  # 今日の天気を調べ、天気に応じて、簡単な運動を促す
  def weather_response(client, event)
    api_client = API::OpenWeatherMap::Client.new

    # 例外が発生した場合は、そのことを利用者に伝えて終了する。
    begin
      forecasts = api_client.fetch_three_hourly_forecasts
    rescue API::TooManyRequestsException => e
      Rails.logger.error("[WebhookController] Error while fetching weather forecast: #{e}")
      message = create_text_object("みんなが一斉に天気を知りたがっているみたい。\n時間をあけてもう一度聞いてね。")
      client.reply_message(event['replyToken'], message)
      return
    rescue => e
      Rails.logger.error("[WebhookController] Error while fetching weather forecast: #{e}")
      message = create_text_object("ごめん、天気を調べられなかったよ。 \n時間をあけてもう一度聞いてね。 ")
      client.reply_message(event['replyToken'], message)
      return
    end

    # 天気を報告
    forecast_three_hours_later = forecasts[0]
    weather_japanese = forecast_three_hours_later.weather_japanese
    weather_message = create_text_object("今日の天気は　#{weather_japanese}　だよ。")

    # 天気に応じて、簡単な運動を促す。
    if forecast_three_hours_later.can_go_out?
      exercise_advice = create_text_object("15~30分だけでも外に出ることをおすすめするよ。\n紫外線を浴びるとビタミンDが作られて、いろいろながんの予防にもなるんだって。\n近くのコンビニにパンでも買いに行こうじゃないか！")
    else
      exercise_advice = create_text_object("外に出られなくても、ちょっとだけ体を動かしてみよう\n大丈夫。　その場で足踏みするだけ！\nポイントは腕をしっかり振って、肘を大きく上げること！\nハイ、１、２，１、２！")
    end

    client.reply_message(event['replyToken'], [weather_message, exercise_advice])
  end
end
