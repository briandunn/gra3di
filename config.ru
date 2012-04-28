require 'coffee_script'
require 'sprockets'

map "/assets" do
  environment = Sprockets::Environment.new
  environment.append_path 'javascripts'
  run environment
end

module Gra3di
  StaticPageApp = Struct.new :path do

    def file
      @file ||= File.read path
    end

    def call(env)
      [
        200,
        {
          'Content-Type'  => 'text/html',
          'Content-Length' => file.bytesize.to_s
        },
        file.each_line
      ]
    end
  end
end

map "/" do
  run Gra3di::StaticPageApp.new 'index.html'
end

map '/spec' do
  run Gra3di::StaticPageApp.new 'spec.html'
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
