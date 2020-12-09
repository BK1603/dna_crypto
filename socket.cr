require "socket"

client = TCPSocket.new("localhost", 8080)
client.puts "Very important message"
response = client.gets
puts response
client.close
