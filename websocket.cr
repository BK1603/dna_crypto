require "http/server"
require "big/big_int"
require "./diffie_hellman"

p = BigInt.new "45739334052801211486383982115714395642859523615469431203095063293408205085850655737540408983027523682219373484935815737826696483347058644040214365601698451568563654746844010747338983871136644386557631185640042912749789107007323073169713214532843785763128771045651074137977867781277726926260077346003", 10
g = BigInt.new "405", 10

ws = HTTP::WebSocket.new("localhost", "/encrypt", 8080)
# ping
ws.ping()

#encrypt key using p, g and private key 97
a = DH.new(BigInt.new 97, p, g)
pub_a = BigInt.new a.get_public_key

ws.send pub_a.to_s

# recieve public key from b

ws.close
