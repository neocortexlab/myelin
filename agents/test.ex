agent "Abc" do
  def construct(_params), do: :ok

  def handle("run", props) do
    IO.inspect(props, label: :props)
  end
end
