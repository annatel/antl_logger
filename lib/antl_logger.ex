defmodule AntlLogger.Formatter do
  def format(level, message, _timestamp, metadata) do
    message
    |> :erlang.iolist_to_binary()
    |> json_msg_format(level, metadata)
    |> new_line()
  end

  def json_msg_format(message, level, metadata) do
    metadata
    |> Enum.into(%{})
    |> Map.drop([:conn, :report_cb])
    |> Map.new(fn
      {:erl_level, _value} -> {:level, level}
      {:domain, value} -> {:domain, Enum.at(value, 0)}
      {:application, _value} -> {:application, Application.get_application(RabbitMQGateway)}
      {key, value} -> {key, "#{inspect(value)}"}
    end)
    |> Map.merge(%{
      message: message,
      status: errors_on(message)
    })
    |> Jason.encode()
    |> case do
      {:ok, msg} -> msg
      {:error, reason} -> %{error: reason} |> Jason.encode()
    end
  end

  def new_line(msg), do: "#{msg}\n"

  defp errors_on(message) when is_binary(message) do
    Regex.compile!("\\w+(?=Error)")
    |> Regex.run(message)
    |> case do
      nil -> "success"
      [error_type] -> error_type <> "Error"
    end
  end

  defp errors_on(_), do: nil
end
