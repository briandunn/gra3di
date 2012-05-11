# =require 'vendor/zepto'
# =require 'seismograph'

# sample integration
# area[n] = sample[n] + (abs(sample[n] - sample[n - 1])/2) * interval
#
# derevation
# rate_of_change[n] = abs(sample[n] - sample[n - 1]) / interval
#
class Sample
  interval: 0
  previous: new Sample

lastSample = 0
integrate = (sample, interval) ->
  sample + (Math.abs(sample - lastSample) / 2) * inverval

class Position
  constructor: (@i)->
    @x()
    @y()

  radius: 200.1
  steps: 20
  angle: -> (@i/@steps) * 2 * Math.PI
  x: -> @x = Math.cos(@angle(@i)) * @radius
  y: -> @y = Math.sin(@angle(@i)) * @radius

$ ->
  viewport = $('div').css overflow: 'hidden', height: 702
  $('body').append viewport
  canvas = $('<canvas/>').css border:'1px solid black'
  canvas[0].height = 700
  canvas[0].width = viewport.width() - 10
  viewport.append canvas
  context = canvas[0].getContext '2d'

  startX = canvas.width() / 2
  startY = canvas.height() / 2
  context.moveTo startX, startY
  dash = (point)->
    context.lineTo startX + point.x, startY + point.y
    context.stroke()

  positions = (new Position i for i in [0..20])
  dash point for point in positions


  if window.DeviceMotionEvent
    origin = new Event
    window.addEventListener 'devicemotion', (e)->
      origin = new Event(origin, e.acceleration, e.interval)
      canvas.lineTo integrate e


