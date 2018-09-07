defmodule Myelin.CompilerTest do
  use ExUnit.Case

  alias Myelin.Compiler

  test "compiles" do
    {:ok, code} = Compiler.compile_file("test")
    {:module, agent} = :code.load_binary(Abc, 'nofile', code)

    assert agent.construct(1) == :ok
  end
end
