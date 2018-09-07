defmodule Myelin.CompilerTest do
  use ExUnit.Case

  alias Myelin.Compiler

  test "compiles" do
    address = "abcdef"
    {:ok, code} = Compiler.compile_file("test", address)
    {:module, agent} = :code.load_binary(String.to_atom(address), 'nofile', code)

    assert agent.construct(1) == :ok
    assert agent.action("run", 33) == 66
    assert agent.task("learn", 3) == 9
  end
end
