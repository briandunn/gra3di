$ ->
  if window.DeviceMotionEvent
    window.addEventListener 'devicemotion', (e)->
      $.post '/motions', e
