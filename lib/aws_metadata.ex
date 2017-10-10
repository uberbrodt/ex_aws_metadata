defmodule AWSMetadata do
  @moduledoc """
  Documentation for AWSMetadata.
  """
  use GenServer
  require Logger 

  defstruct [:client]

  @alert_before_expiry -5
  @retry_delay 5_000

  def get_client do
    GenServer.call(__MODULE__, :get_client)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, client} = fetch_client()
    {:ok, %AWSMetadata{client: client}}
  end

  def handle_call(:get_client, _from, %{client: client} = state) do
    {:reply, client, state}
  end

  def handle_info(:refresh_client, state) do
    {:ok, client} = fetch_client()
    {:noreply, %{state | client: client}}
  end

  defp fetch_client do
    {:ok, client, expiration_time} = AWSMetadata.Client.fetch()
    setup_update_callback(expiration_time)
    {:ok, client}
  rescue
    e -> 
      Logger.info(":ex_aws_metadata ignoring exception fetching client: #{inspect(e)}")
      setup_retry_callback()
      {:ok, nil}
  end

  defp setup_update_callback(expiration_time) do
    exp_time = DateTime.diff(expiration_time, minutes: @alert_before_expiry)
    refresh_ms = DateTime.to_unix(exp_time, :millisecond) - System.system_time(:millisecond)
    Process.send_after(__MODULE__, :refresh_client, refresh_ms)
  end

  defp setup_retry_callback do
    Process.send_after(__MODULE__, :refresh_client, @retry_delay)
  end
end
