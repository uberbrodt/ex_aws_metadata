defmodule AWSMetadata.Client do
  
  @credential_url "http://169.254.169.254/latest/meta-data/iam/security-credentials/"
  @document_url "http://169.254.169.254/latest/dynamic/instance-identity/document"
  
  def fetch do
    role = fetch_role()
    metadata = fetch_metadata(role)
    region = fetch_document()
    client_map = %{
      access_key_id: metadata[:access_key_id],
      secret_access_key: metadata[:secret_access_key],
      region: region,
      token: metadata[:token],
      endpoint: "amazonaws.com"
    }
    client = struct(AWS.Client, client_map)
    {:ok, exp_datetime, 0} = DateTime.from_iso8601(metadata[:expiration])
    {:ok, client, exp_datetime}
  end

  defp fetch_role do
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(@credential_url)
    body
  end

  defp fetch_metadata(role) do
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!("#{@credential_url}#{role}")
    result = Poison.decode!(body)
    %{access_key_id: result["AccessKeyId"],
      secret_access_key: result["SecretAccessKey"],
      token: result["Token"],
      expiration: result["Expiration"]
    }
  end

  defp fetch_document do
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(@document_url)
    Poison.decode!(body) |> Map.get("region")
  end
end
