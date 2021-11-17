require 'test_helper'
require_relative '../../../../app/models/api/open_weather_map/weathers'

module API
  module OpenWeatherMap
    class HourlyWeatherTest < ActiveSupport::TestCase

      def test_can_go_out
        clear = HourlyWeather.new(time_unix: 0, temperature: 0, weather: Weathers::CLEAR)
        assert clear.can_go_out?

        cloud = HourlyWeather.new(time_unix: 0, temperature: 0, weather: Weathers::CLOUDS)
        assert cloud.can_go_out?

        rain = HourlyWeather.new(time_unix: 0, temperature: 0, weather: Weathers::RAIN)
        assert_not rain.can_go_out?
      end
    end

  end
end
