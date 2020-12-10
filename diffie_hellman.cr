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
