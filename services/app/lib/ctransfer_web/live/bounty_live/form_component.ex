defmodule CTransferWeb.BountyLive.FormComponent do
  @moduledoc false
  use CTransferWeb, :live_component

  alias CTransfer.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage bounty records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="bounty-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:date_created]} type="datetime-local" label="Date created" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:date_closed]} type="datetime-local" label="Date closed" />
        <.input field={@form[:funds_amount]} type="number" label="Funds amount" step="any" />
        <.input field={@form[:funds_currency]} type="text" label="Funds currency" />
        <.input field={@form[:attachments]} type="select" multiple label="Attachments" options={[]} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Bounty</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{bounty: bounty} = assigns, socket) do
    changeset = Transactions.change_bounty(bounty)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"bounty" => bounty_params}, socket) do
    changeset =
      socket.assigns.bounty
      |> Transactions.change_bounty(bounty_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"bounty" => bounty_params}, socket) do
    save_bounty(socket, socket.assigns.action, bounty_params)
  end

  defp save_bounty(socket, :edit, bounty_params) do
    case Transactions.update_bounty(socket.assigns.bounty, bounty_params) do
      {:ok, bounty} ->
        notify_parent({:saved, bounty})

        {:noreply,
         socket
         |> put_flash(:info, "Bounty updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_bounty(socket, :new, bounty_params) do
    case Transactions.create_bounty(bounty_params) do
      {:ok, bounty} ->
        notify_parent({:saved, bounty})

        {:noreply,
         socket
         |> put_flash(:info, "Bounty created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
