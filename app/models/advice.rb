class Advice
  SLEEP_ADVICES = [
    "朝起きても、なんだか寝た気がしないときがあるよね。\n寝る直前にご飯を食べると、消化するためにエネルギーを使うから、睡眠に良くないらしい。\n食事は寝る3時間前に済ませるか、消化に良いものを食べると睡眠に影響を与えにくいよ！",
  ]
  DIET_ADVICES = [
    "ご飯を食べるときに、野菜を先に食べたほうがいいって言うよね。\nいろいろ理由はあるんだけど、野菜は食べるのにたくさん噛む必要があるから、脳が満腹感を感じて、どか食いを防げるんだって。",
  ]
  HEALTH_ADVICES = [
    "１時間座り続けると、寿命が22分も縮まるんだって！\n30分に１回立ち上がるだけで、リスクを減らせるみたいだよ。\n今がその時だ！",
  ]

  attr_reader :type
  attr_reader :message

  def initialize(type:, message:)
    @type = type
    @message = message
  end

  # 全てのアドバイスを取得する
  # @return [Array<Advice>]
  def self.all
    sleep_advices = SLEEP_ADVICES.map { |advice| Advice.new(type: "sleep", message: advice) }
    diet_advices = DIET_ADVICES.map { |advice| Advice.new(type: "diet", message: advice) }
    health_advices = HEALTH_ADVICES.map { |advice| Advice.new(type: "health", message: advice) }
    sleep_advices + diet_advices + health_advices
  end
end
