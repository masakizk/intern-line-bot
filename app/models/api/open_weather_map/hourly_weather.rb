module API
  module OpenWeatherMap
    class HourlyWeather
      attr_reader :time
      attr_reader :temperature
      attr_reader :weather

      def initialize(time:, temperature:, weather:)
        @time = time
        @temperature = temperature
        @weather = weather
      end

      def self.from_json(json)
        HourlyWeather.new(
          time: Time.at(json["dt"]),
          temperature: json["main"]["temp"],
          weather: json["weather"][0]["main"]
        )
      end
    end
  end
end
