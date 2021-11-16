class Advice
  attr_reader :sleep_advices
  attr_reader :diet_advices
  attr_reader :health_advices

  def initialize
    @sleep_advices = [
      "朝起きても、なんだか寝た気がしないときがあるよね。\n寝る直前にご飯を食べると、消化するためにエネルギーを使うから、睡眠に良くないらしい。\n食事は寝る3時間前に済ませるか、消化に良いものを食べると睡眠に影響を与えにくいよ！"
    ]
    @diet_advices = [
      "ご飯を食べるときに、野菜を先に食べたほうがいいって言うよね。\nいろいろ理由はあるんだけど、野菜は食べるのにたくさん噛む必要があるから、脳が満腹感を感じて、どか食いを防げるんだって。",
    ]
    @health_advices = [
      "１時間座り続けると、寿命が22分も縮まるんだって！\n30分に１回立ち上がるだけで、リスクを減らせるみたいだよ。\n今がその時だ！",
    ]
  end

  # 全てのアドバイスを取得する
  def all
    @sleep_advices + @diet_advices + @health_advices
  end
end
