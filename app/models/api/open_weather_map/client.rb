module API
  module OpenWeatherMap
    class Client
      FORECAST_ENDPOINT = "https://api.openweathermap.org/data/2.5/forecast"

      # @return [Array<HourlyWeather>] 5日間分の3時間ごとの天気予報
      def fetch_three_hourly_forecasts(location = "tokyo")
        client = HTTPClient.new
        response = client.get(FORECAST_ENDPOINT, {
          q: location,
          appid: ENV["OPEN_WEATHER_MAP_API_KEY"],
          units: "metric"
        })

        response_json = JSON.parse(response.body)
        forecasts = response_json["list"].map { |forecast| HourlyWeather.from_json(forecast) }
        return forecasts
      end
    end
  end
end
