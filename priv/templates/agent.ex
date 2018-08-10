agent "{{address}}" do
  def construct() do
    :ok
  end

  def payload(props) do
    :ok
  end

  def handle(action, props) do
    case action do
      "run" -> payload(props)
    end
  end
end
