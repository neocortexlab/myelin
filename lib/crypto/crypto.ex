defmodule Crypto do
  @type hash :: binary()
  @type address :: <<_::160>>

  @spec hash(binary()) :: hash
  def hash(data), do: :crypto.hash(:sha256, data)

  def gen_key_pair() do
    {_secret_key, _public_key} = Ed25519.generate_key_pair()
  end

  def gen_address(public_key), do: public_key |> hash()

  @spec from_hex(String.t()) :: binary()
  def from_hex(hex_data), do: Base.decode16!(hex_data, case: :lower)

  @spec to_hex(binary()) :: String.t()
  def to_hex(bin), do: Base.encode16(bin, case: :lower)
  
end
