require 'test_helper'

module API
  module OpenWeatherMap
    class HourlyWeatherTest < ActiveSupport::TestCase

      def test_can_go_out
        sunny = HourlyWeather.new(time_unix: 0, temperature: 0, weather: CLEAR)
        assert sunny.can_go_out?
      end
    end

  end
end
