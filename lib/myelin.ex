defmodule Myelin do
  @moduledoc """
  Documentation for Myelin.
  """

  # def connect do
  #   Neuron.Config.set(url: "http://localhost:8080/api")
  #   Neuron.query("""
  #   {
  #     agent(address: "2") {
  #       address
  #       balance
  #     }
  #   }
  #   """)
  # end

  def init(), do: Neuron.Config.set(url: "http://localhost:8080/api")

  def new_agent(code) do
      {:ok, response} = Neuron.query("""
                        {
                          newAgent(code: "#{code}") {
                            rlp
                          }
                        }
                        """)

      response.body["data"]["newAgent"]["rlp"]
  end

  def create_agent() do
    {secret_key, public_key} = Ed25519.generate_key_pair()
    address = Crypto.gen_address(public_key) |> Crypto.to_hex()
    code = Examples.Agents.get_agent("simple", address) |> Crypto.to_hex()
    deploy_agent(address, code)
  end

  def deploy_agent(address, code) do
    rlp = new_agent(code)

    """
      CreateTx {
        sendTx(to: "#{address}",
             from: "",
             value: 0
             type: "create",
             data: "#{rlp}"
             ) {
          rlp
        }
      }
    """
    |> Neuron.mutation()
  end

end
