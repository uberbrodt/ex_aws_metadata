defmodule AWSMetadataTest do
  use ExUnit.Case
  doctest AWSMetadata

  defmodule TestMetadataClient do
    def fetch do
      client_map = %{
        access_key_id: "ACCESS_KEY_ID" ,
        secret_access_key: "SECRET_ACCESS_KEY",
        region: "us-east-1",
        token: "TOKEN",
        endpoint: "amazonaws.com"
      }
      client = struct(AWS.Client, client_map)
      {:ok, exp_datetime, 0} = DateTime.from_iso8601("2017-10-10T06:31:52Z")
      {:ok, client, exp_datetime}
    end
  end

  test "that it actually works" do
    {:ok, pid} = AWSMetadata.start_link([metadata_client: TestMetadataClient])
    %AWS.Client{access_key_id: "ACCESS_KEY_ID", endpoint: "amazonaws.com", port: "443", proto: "https", region: "us-east-1", secret_access_key: "SECRET_ACCESS_KEY", service: nil, token: "TOKEN"} = AWSMetadata.get_client()
  end

end
