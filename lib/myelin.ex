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
    {:ok, response} =
      Neuron.query("""
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

    {:ok, response} =
      """
        CreateAgent {
          create(address: "#{address}",
                agent: "#{rlp}"
              ) {
            hash
            height
            data
          }
        }
      """
      |> Neuron.mutation()

    response.body["data"]["create"]
  end

  def send_msg(to, action, props) do
    rlp_hex = new_message(action, props)

    {:ok, response} =
      """
        SendMessage {
          sendMsg(to: "#{to}", message: "#{rlp_hex}") {
            hash
            height
            data
          }
        }
      """
      |> Neuron.mutation()

    response.body["data"]["sendMsg"]["data"]
    |> decode()
  end

  defp decode(nil), do: nil
  defp decode(val), do: Base.decode64(val)

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

  def check_tx(hash) do
    {:ok, response} =
      """
        CheckTx {
          checkTx(hash: "#{hash}") {
            hash
            height
            data

          }
        }
      """
      |> Neuron.mutation()

    response.body["data"]["checkTx"]
  end

  def bid(address, %{} = bid) do
    bid_params =
      bid
      |> Enum.map(fn {k, v} -> ~s(#{k}: "#{v}") end)
      |> Enum.join(", ")

    response =
      request("""
        Bid {
          bid(from: "#{address}", #{bid_params}) {
            hash
            height
            data
          }
        }
      """)

    response.body
  end

  defp request(request) do
    case Neuron.mutation(request) do
      {:ok, response} -> response
      {:error, response} ->
        response.body["errors"]
        |> Enum.map(&(&1["message"]))
        |> Enum.join("\n")
        |> IO.puts()
        exit("Request failed")
    end
  end
end
