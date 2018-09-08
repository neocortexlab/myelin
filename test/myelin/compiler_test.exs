defmodule Myelin.CompilerTest do
  use ExUnit.Case

  alias Myelin.Compiler
  alias Cmd.Utils

  test "compiles" do
    address = "abcdef"
    {:ok, agent_src} = Utils.read_agent_source("test")
    {:ok, code} = Compiler.compile_agent(agent_src, address)
    {:module, agent} = :code.load_binary(String.to_atom(address), 'nofile', code)

    assert agent.construct(1) == :ok
    assert agent.action("run", 33) == 66
    assert agent.task("learn", 3) == 9
  end
end
