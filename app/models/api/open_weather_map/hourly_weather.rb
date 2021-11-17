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
    end
  end
end
