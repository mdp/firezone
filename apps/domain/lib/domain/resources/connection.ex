defmodule Domain.Resources.Connection do
  use Domain, :schema

  @primary_key false
  schema "resource_connections" do
    belongs_to :resource, Domain.Resources.Resource, primary_key: true
    belongs_to :gateway, Domain.Gateways.Gateway, primary_key: true

    belongs_to :account, Domain.Accounts.Account
  end
end
