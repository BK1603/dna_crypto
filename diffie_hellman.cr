require "big/big_int"

@[Link("gmp")]
lib LibGMP
  fun mpz_powm_sec = __gmpz_powm_sec(rop : MPZ*, base : MPZ*, exp : MPZ*, mod : MPZ*)
end

def modular_expo(base :  BigInt, power :  BigInt, mod :  BigInt) : BigInt
  print base, " ", power
  print "\n"
  if base == 0
    return 0_u64
  end
  if power == 1
    return base
  elseif power % 2 == 0
    return ((modular_expo(base, power//2, mod) % mod) * (modular_expo(base, power//2, mod) % mod) % mod)
  else
    return (base % mod * (modular_expo(base, power//2, mod) % mod) * (modular_expo(base, power//2, mod) % mod) % mod)
  end
end

class DH
  private property private_key : BigInt
  private property p : BigInt
  private property g : BigInt

  def initialize()
    @private_key = uninitialized BigInt
    @p = uninitialized BigInt
    @g = uninitialized BigInt
  end

  def initialize(pk : BigInt, p : BigInt, g :  BigInt)
    @private_key = pk
    @p = p
    @g = g
  end

  def set_private_key(k : BigInt)
    @private_key = k
  end

  def get_private_key()
    @private_key
  end

  def get_public_key()
    public_key = BigInt.new
    LibGMP.mpz_powm_sec(public_key, @g, @private_key, @p)
    return public_key
  end

  def get_secret_key(pub_key : BigInt) : BigInt
    secret_key = BigInt.new
    LibGMP.mpz_powm_sec(secret_key, pub_key, @private_key, @p)
    return secret_key
  end
end

p = BigInt.new "45739334052801211486383982115714395642859523615469431203095063293408205085850655737540408983027523682219373484935815737826696483347058644040214365601698451568563654746844010747338983871136644386557631185640042912749789107007323073169713214532843785763128771045651074137977867781277726926260077346003", 10
g = BigInt.new 405

a = DH.new BigInt.new(97), p, g
b = DH.new BigInt.new(233), p, g

pub_a = BigInt.new a.get_public_key
pub_b = BigInt.new b.get_public_key

puts pub_a, "\n"
puts pub_b, "\n"

puts(a.get_secret_key(pub_b), "\n")
puts(b.get_secret_key(pub_a), "\n")
