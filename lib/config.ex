defmodule Config do

  def configure(configs) do
    Enum.each(configs, fn
      ({app})-> Application.get_all_env(app) |> Enum.each(fn({k, v})-> Application.put_env(app, k, transform(v)) end)
      ({app, key})-> configure_env(app, key)
    end)
  end

  defp configure_env(app, key) do
    updated_env =
      Application.get_env(app, key)
      |> Enum.map(fn({k, v})-> {k, transform(v)} end)
    Application.put_env(app, key, updated_env)
  end

  defp transform({:system, env_var}) do
    System.get_env(env_var)
  end
  defp transform(val) do
    val
  end

end

