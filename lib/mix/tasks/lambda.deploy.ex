defmodule Mix.Tasks.Lambda.Deploy do
  use Mix.Task

  @shortdoc "deploys a lambda function from the lambda/ folder, usage: mix lambda.deploy check_url. depends on local aws and zip commands"
  def run(function_name) do

    Mix.shell.info "zipping #{function_name}"
    exec "rm", ~w[-rf /tmp/#{function_name}.zip]
    exec "zip", ~w[--junk-paths /tmp/#{function_name}.zip ./lambda/#{function_name}/index.js]

    Mix.shell.info "deploying #{function_name}"
    exec "aws", ~w[lambda update-function-code --function-name #{function_name} --zip-file fileb:///tmp/#{function_name}.zip]

    Mix.shell.info "DONE"
  end

  require Logger
  defp exec(cmd, args) do
    Mix.shell.info(inspect [cmd, args])
    {out, 0} = System.cmd(cmd, args)
    Mix.shell.info out
  end

end
