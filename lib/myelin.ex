defmodule Myelin do
  @moduledoc """
  Documentation for Myelin.
  """

  alias PalliumCore.Core.{Agent,Bid,Message}
  alias PalliumCore.Crypto

  def init(), do: Neuron.Config.set(url: "http://localhost:8080/api")

  def deploy_agent(address, code, %{} = params) do
    rlp = %Agent{code: code} |> Agent.encode(:hex)
    encoded_params = Crypto.encode_map(params)

    response =
      request("""
        CreateAgent {
          create(address: "#{address}", agent: "#{rlp}", params: "#{encoded_params}") {
            hash
            height
            data
          }
        }
      """)

    response.body["data"]["create"]
  end

  def send_msg(to, action, props) do
    rlp_hex = %Message{action: action, props: props} |> Message.encode(:hex)

    response =
      request("""
        SendMessage {
          sendMsg(to: "#{to}", message: "#{rlp_hex}") {
            hash
            height
            data
          }
        }
      """)

    response.body["data"]["sendMsg"]["data"]
    |> decode()
  end

  defp decode(nil), do: nil
  defp decode(val), do: Base.decode64!(val)

  def check_tx(hash) do
    response =
      request("""
        CheckTx {
          checkTx(hash: "#{hash}") {
            hash
            height
            data

          }
        }
      """)

    response.body["data"]["checkTx"]
  end

  def bid(address, %Bid{} = bid) do
    bid_rlp = bid |> Bid.encode(:hex)

    response =
      request("""
        Bid {
          bid(from: "#{address}", bid: "#{bid_rlp}") {
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
      {:ok, response} ->
        print_errors(response)
        response

      {:error, response} ->
        print_errors(response)
        exit("Request failed")
    end
  end

  defp print_errors(%HTTPoison.Error{} = error) do
    IO.puts("Connection error: #{inspect error}")
  end

  defp print_errors(response) do
    case response.body["errors"] do
      nil -> :ok
      errors ->
        errors
        |> Enum.map(& &1["message"])
        |> Enum.join("\n")
        |> IO.puts()
    end
  end
end
