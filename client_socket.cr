require "http/server"
require "big/big_int"
require "./diffie_hellman"

client = TCPSocket.new("localhost", 8080)
response = client.gets || ""

r = response.split(",")
p = BigInt.new(r[0], 10)
g = BigInt.new(r[1], 10)

# create public key using above and share
c = DH.new(BigInt.new(97), p, g)
pub_c = BigInt.new(c.get_public_key())

s_s = client.gets()
pub_s = BigInt.new(s_s || "0", 10)
client.puts(pub_c.to_s)

sec_s = c.get_secret_key(pub_s)

puts "p :", p, "\n", "g :", g, "\n"
puts "pub_s: ", pub_s, "\n"
puts "pub_c: ", pub_c, "\n"
puts "Secret: ", sec_s, "\n"
puts "Server gave: ", pub_s, "\n"

# extract the key
key = extract_key(pub_s)

# use the key to encrypt the message
message = "hello how are you?"
data = DNA.encrypt(key, message)

#send to server
client.puts(data)

client.close()
