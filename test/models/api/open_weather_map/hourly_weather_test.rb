require 'test_helper'

module API
  module OpenWeatherMap
    class HourlyWeatherTest < ActiveSupport::TestCase

      def test_can_go_out
        [
          # [天気、外出することができるか]
          [Weathers::CLEAR, true],
          [Weathers::CLOUDS, true],
          [Weathers::RAIN, false],
          ["Hoge", false], # 想定される天気でない場合はfalse
          ["clear", false] # 最初は大文字でないといけない。
        ].each do |input, expected|
          weather = HourlyWeather.new(time_unix: 0, temperature: 0, weather: input)
          assert weather.can_go_out? == expected,
                 "can_go_out?(#{input}) is expected: #{expected} but actual: #{weather.can_go_out?}"
        end
      end
    end

  end
end
