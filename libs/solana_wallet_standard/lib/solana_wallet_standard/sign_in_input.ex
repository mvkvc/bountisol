defmodule SolanaWalletStandard.SignInInput do
  defstruct [
    :domain,
    :address,
    :statement,
    :uri,
    :version,
    :chain_id,
    :nonce,
    :issued_at,
    :expiration_time,
    :not_before,
    :request_id,
    :resources
  ]

  def create() do
    now = DateTime.utc_now() |> DateTime.to_iso8601()
    uri = "Your method to get the current URL here"
    domain = URI.parse(uri).host

    # %__MODULE__{
    #   domain: domain,
    #   statement:
    #     "Clicking Sign or Approve only means you have proved this wallet is owned by you. This request will not trigger any blockchain transaction or cost any gas fee.",
    #   version: "1",
    #   nonce: "oBbLoEldZs",
    #   chain_id: "mainnet",
    #   issued_at: now,
    #   resources: ["https://example.com", "https://phantom.app/"]
    # }
    %__MODULE__{}
  end
end
