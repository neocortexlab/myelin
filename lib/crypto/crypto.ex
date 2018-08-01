defmodule Crypto do
  @type keccak_hash :: binary()
  @type address :: <<_::160>>

  @spec keccak(binary()) :: keccak_hash
  def keccak(data), do: :keccakf1600.sha3_256(data)

  def gen_key_pair() do
    {secret_key, public_key} = Ed25519.generate_key_pair()
  end

  def gen_address(public_key), do: public_key |> keccak()

  @spec from_hex(String.t()) :: binary()
  def from_hex(hex_data), do: Base.decode16!(hex_data, case: :lower)

  @spec to_hex(binary()) :: String.t()
  def to_hex(bin), do: Base.encode16(bin, case: :lower)
  
end
