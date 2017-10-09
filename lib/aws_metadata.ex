defmodule AWSMetadata do
  require Logger 
  defstruct [:client]

  @alert_before_expiry -5
  @retry_delay 5_000

  @moduledoc """
  Documentation for AWSMetadata.
  """
  use GenServer

  def get_client do
    GenServer.call(__MODULE__, :get_client)
  end

  def init(_) do
    {:ok, client} = fetch_client()
    {:ok, %AWSMetadata{client: client}}
  end

  def handle_call(:get_client, %{client: client} = state) do
    {:reply, client, state}
  end

  defp fetch_client do
    {:ok, client, expiration_time} = AWSMetadata.Client.fetch()
    setup_update_callback(expiration_time)
    {:ok, client}
  rescue
    _ -> 
      Logger.info(":ex_aws_metadata ignoring exception fetching client")
      setup_retry_callback()
      {:ok, nil}
  end

  defp setup_update_callback(expiration_time) do
    exp_time = DateTime.diff(expiration_time, minutes: -5)
    refresh_ms = DateTime.to_unix(exp_time, :millisecond) - System.system_time(:millisecond)
    Process.send_after(__MODULE__, :refresh_client, refresh_ms)
  end

  defp setup_retry_callback do
    Process.send_after(__MODULE__, :refresh_client, @retry_delay)
  end
end
