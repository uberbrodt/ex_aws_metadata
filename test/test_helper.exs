Application.load(:ex_aws_metadata)
for app <- Application.spec(:ex_aws_metadata, :applications) do
  Application.ensure_all_started(app)
end
ExUnit.start()
