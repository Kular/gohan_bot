responses = ['要吃就吃肉牛犊！', '来，干了这碗肉牛犊再上路吧', '那么问题来了，到底吃啥呢？', '好吃还是肉牛犊', '老板，来5斤肉牛犊，要热的！', '如何解决农民吃饭难问题，成了当下政府面临任务中的重中之重']

module.exports = (robot) ->
  robot.hear /(吃|飯|饭|饿|飢|餓|食|食)|^(hungry|hunger)$/i, (res) -> 
    res.send res.random responses
