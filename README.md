# AWSMetadata

An Elixir app to query authorization credentials via EC2 metadata. This is 
a built-in feature for at least some of Amazon's official SDKs. Intended to be
used in conjunction with any AWS library.

## Usage

```elixir
client = AWSMetadata.get_client()
iex(1)> client = AWSMetadata.get_client()
%{
    access_key_id: "ACCESS_KEY_ID",
    endpoint: "amazonaws.com",
    region: "us-east-1",
    secret_access_key: "SECRET_ACCESS_KEY",
    token: "TOKEN"
}

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_aws_metadata` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_aws_metadata, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_aws_metadata](https://hexdocs.pm/ex_aws_metadata).

