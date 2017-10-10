defmodule AWSMetadata do
  @moduledoc """
  Documentation for AWSMetadata.
  """
  use GenServer
  require Logger 

  defstruct [:client, :metadata_client]

  @alert_before_expiry -5
  @retry_delay 5_000

  def get_client do
    GenServer.call(__MODULE__, :get_client)
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    state = %AWSMetadata{metadata_client: Keyword.get(args, :metadata_client, AWSMetadata.Client)}
    {:ok, client} = fetch_client(state.metadata_client)
    {:ok, %{state | client: client}}
  end

  def handle_call(:get_client, _from, %{client: client} = state) do
    {:reply, client, state}
  end

  def handle_info(:refresh_client, %{metadata_client: metadata_client} = state) do
    {:ok, client} = fetch_client(metadata_client)
    {:noreply, %{state | client: client}}
  end

  defp fetch_client(metadata_client) do
    {:ok, client, expiration_time} = metadata_client.fetch()
    setup_update_callback(expiration_time)
    {:ok, client}
  rescue
    e -> 
      Logger.info(":ex_aws_metadata ignoring exception fetching client: #{inspect(e)}")
      Logger.info(inspect(System.stacktrace, pretty: true))
      setup_retry_callback()
      {:ok, nil}
  end

  defp setup_update_callback(expiration_time) do
    exp_time = Timex.shift(expiration_time, minutes: @alert_before_expiry)
    refresh_ms = DateTime.to_unix(exp_time, :millisecond) - System.system_time(:millisecond)
    Process.send_after(__MODULE__, :refresh_client, refresh_ms)
  end

  defp setup_retry_callback do
    Process.send_after(__MODULE__, :refresh_client, @retry_delay)
  end
end
