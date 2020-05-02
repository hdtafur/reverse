defmodule Reverse.Words.Word do
  use Ecto.Schema
  import Ecto.Changeset

  schema "words" do
    field :body, :string

    timestamps()
  end

  @doc false
  def changeset(word, attrs) do
    word
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
