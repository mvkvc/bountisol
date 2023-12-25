defmodule CTransfer.Jobs.NotifyPayment do
    use Oban.Worker, queue: :mailer
    import Swoosh.Email

    # If payment is a request notify recipient
    # Send email saying a user has requested
    # Link back to open send page

    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"email" => email} = args}) do
    end

    defp send() do
    end
end
