module API
  module OpenWeatherMap
    class Client
      BASE_URL = "https://api.openweathermap.org"
      TOO_MANY_REQUESTS = 429

      def initialize
        @connection = Faraday.new(url: BASE_URL) do |faraday|
          faraday.options[:timeout] = 5
        end
      end

      # @return [Array<HourlyWeather>] 3時間ごとの12時間分の天気予報
      def fetch_three_hourly_forecasts(location = "tokyo")
        response = @connection.get("/data/2.5/forecast", {
          q: location,
          appid: ENV["OPEN_WEATHER_MAP_API_KEY"],
          units: "metric",
          lang: "ja",
          cnt: 4 # 12時間分の天気予報を取得する
        })

        unless response.success?
          case response.status
          when TOO_MANY_REQUESTS then
            raise TooManyRequestsException.new("Free subscription can make 60 API calls per minute.")
          else
            raise RuntimeError.new("Open Weather Map Api request was failed(Status Code: #{response.status})")
          end
        end

        response_json = JSON.parse(response.body)
        forecasts = response_json["list"].map { |forecast| HourlyWeather.from_json(forecast) }
        return forecasts
      end
    end
  end
end
