defmodule {{module}} do
  import Myelin.Agent
  alias Pallium.Env

  @self "{{address}}"

  def start_task(agent, task), do: Env.start_task(@self, agent, task)
  def get_value(key), do: Env.get_value(@self, key)
  def set_value(key, value), do: Env.set_value(@self, key, value)
  def set_state(state), do: Env.set_state(@self, state)

  {{code}}
end
