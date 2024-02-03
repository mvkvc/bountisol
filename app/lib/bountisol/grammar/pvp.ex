defmodule Bountisol.Grammar.PVP do
    @moduledoc false
    import Ecto.Changeset

    def generate_json_schema(users) do
        schema = %{
            "$schema" => "https://json-schema.org/draft/2020-12/schema",
            "$id" => "https://example.com/product.schema.json",
            "title" => "Arbitration",
            "description" => "Results from arbitration.",
            "type" => "object",
            "properties" => %{
              "awardee" => %{
                "description" => "The individual or group that is awarded the funds.",
                "type" => "string",
                "enum" => users
              },
            "required" => ["awardee"]
          }
        }

        case Portboy.run_pool(:js, "json_schema_to_gbnf", %{schema: schema}) do
            {:ok, result} ->
              IO.inspect(result, label: "JSON Schema to GBNF")

            {:error, reason} ->
              Logger.error("Error: #{inspect(reason)}")
          end
    end
end
