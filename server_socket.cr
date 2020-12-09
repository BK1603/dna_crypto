require "http/server"

server = HTTP::WebSocket.new("localhost", "/encrypt", 8080)
puts "Listening on 8080"
server.run

server.on_message do |msg|
  puts msg
end

server.close
