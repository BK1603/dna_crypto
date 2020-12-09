require "http/server"
require "big/big_int"
#require "./dna_algo"

# use a socket handler to recieve the key ig

p = 353
g = 3

ws_handler = HTTP::WebSocketHandler.new do |client, ctx|
  client.on_ping do
    puts "Pinged\n"
    client.send("45739334052801211486383982115714395642859523615469431203095063293408205085850655737540408983027523682219373484935815737826696483347058644040214365601698451568563654746844010747338983871136644386557631185640042912749789107007323073169713214532843785763128771045651074137977867781277726926260077346003,405")
  end
end

server = HTTP::Server.new([
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new(log = Log.for("http.server")),
  HTTP::StaticFileHandler.new("."),
  ws_handler,
])

address = server.bind_tcp 8080
puts "Listening on #{address}"
server.listen
