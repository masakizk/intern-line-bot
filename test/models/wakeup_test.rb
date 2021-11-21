require 'test_helper'

class WakeupTest < ActiveSupport::TestCase
  test "wakeup_early" do
    now = Time.now
    [
      # [時間、早起きか]
      [now.change(hour: 3, minute: 59), false],
      [now.change(hour: 4, minute: 00), true],
      [now.change(hour: 7, minute: 59), true],
      [now.change(hour: 8, minute: 00), false],
    ].each do |input, expected|
      wakeup = Wakeup.new(wakeup_at: input)
      assert_equal expected, wakeup.early?, "Wakeup#early?(#{input}) is expected: #{expected} but actual: #{wakeup.early?}"
    end
  end
end
