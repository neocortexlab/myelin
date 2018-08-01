defmodule Examples.Agents do

  def get_agent(name, address) do
    agent = case name do
              "simple" -> simple_agent(address)
            end

    [{_, agent_code}] = Code.compile_quoted(agent)

    :code.purge(String.to_atom(address))
    :code.delete(String.to_atom(address))

    agent_code
  end

  def simple_agent(address) do
    agent_atom = {:__aliases__, [alias: false], [String.to_atom(address)]}
      quote do
        defmodule unquote(agent_atom) do
          #@behaviour Pallium.Env.AgentBehaviour
          @self unquote(address)

          def construct(agent) do
            state = %{foo: "bar", hello: "Hello, world!"}
            Pallium.Env.set_state(agent, state)
          end

          def handle(action, data) do
            case action do
              "foo" ->   Pallium.Env.get_value(@self, "foo")
              "hello" -> Pallium.Env.get_value(@self, "hello") |> Pallium.Env.in_chan(@self)
            end
          end
        end
      end
  end
end
