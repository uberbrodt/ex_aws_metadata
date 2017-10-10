defmodule AWSMetadataTest do
  use ExUnit.Case
  doctest AWSMetadata

  defmodule TestMetadataClient do
    def fetch do
      client = %{
        access_key_id: "ACCESS_KEY_ID" ,
        secret_access_key: "SECRET_ACCESS_KEY",
        region: "us-east-1",
        token: "TOKEN",
        endpoint: "amazonaws.com"
      }
      {:ok, exp_datetime, 0} = DateTime.from_iso8601("2030-10-10T06:31:52Z")
      {:ok, client, exp_datetime}
    end
  end

  test "that it actually works" do
    {:ok, pid} = AWSMetadata.start_link([metadata_client: TestMetadataClient])

    %{access_key_id: "ACCESS_KEY_ID", endpoint: "amazonaws.com", region: "us-east-1", secret_access_key: "SECRET_ACCESS_KEY", token: "TOKEN"} = AWSMetadata.get_client()
  end

end
