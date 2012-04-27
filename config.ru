require 'coffee_script'
require 'sprockets'
require 'pp'

map "/assets" do
  environment = Sprockets::Environment.new
  environment.append_path 'javascripts'
  run environment
end

map "/" do
  run ->(env) {
    index = File.open 'index.html'
    [
      200,
      {
        'Content-Type'  => 'text/html',
        'Content-Length' => index.size.to_s
      },
      index
    ]
  }
end

EVENTS = []

map '/motions' do
  run ->(env) {
    EVENTS.push env['rack.input'].read
    [201, {'Content-Type'  => 'text/plain'}, 'ok'.each_line]
  }
end

at_exit do
  File.open 'events.json', 'w+' do |f|
    f.write MultiJson.dump EVENTS
  end
end
