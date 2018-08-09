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
    {_secret_key, public_key} = Ed25519.generate_key_pair()
    address = Crypto.gen_address(public_key) |> Crypto.to_hex()
    code = Examples.Agents.get_agent("simple", address) |> Crypto.to_hex()
    deploy_agent(address, code)
  end

  def deploy_agent(address, code) do
    rlp = new_agent(code)

    """
      CreateAgent {
        create(address: "#{address}",
              agent: "#{rlp}"",
            ) {
          rlp
        }
      }
    """
    |> Neuron.mutation()
  end

  def send_msg(to, action, props) do
    rlp = new_message(action, props)
    {:ok, response} =
      """
        SendMessage {
          sendMsg(from: "", to: "#{to}", message: "#{rlp}") {
            rlp
          }
        }
      """
      |> Neuron.mutation()
    response.body["data"]["sendMsg"]["rlp"]
  end

  defp new_message(action, props) do
    {:ok, response} =
      """
      {
        newMessage(action:"#{action}", props:"#{props}") {
          rlp
        }
      }
      """
      |> Neuron.query()
    response.body["data"]["newMessage"]["rlp"]
  end

end
