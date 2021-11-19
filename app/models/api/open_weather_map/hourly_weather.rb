require_relative 'weathers'

module API
  module OpenWeatherMap
    class HourlyWeather
      attr_reader :time_unix, :temperature, :weather

      def initialize(time_unix:, temperature:, weather:)
        @time_unix = time_unix
        @temperature = temperature
        @weather = weather
      end

      def self.from_json(json)
        HourlyWeather.new(
          time_unix: json["dt"],
          temperature: json["main"]["temp"],
          weather: json["weather"][0]["main"]
        )
      end

      # 外出できる天気かどうかを判定する。
      def can_go_out?
        [Weathers::CLEAR, Weathers::CLOUDS].include?(@weather)
      end

      def weather_japanese
          case @weather
          when Weathers::THUNDERSTORM then
            "雷"
          when Weathers::DRIZZLE then
            "霧雨"
          when Weathers::RAIN then
            "雨"
          when Weathers::SNOW then
            "雪"
          when Weathers::CLEAR then
            "晴れ"
          when Weathers::CLOUDS then
            "曇り"
          else
            "不明"
          end
      end
    end
  end
end
