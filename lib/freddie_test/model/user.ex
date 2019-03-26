defmodule FreddieTest.Model.User do
  use Ecto.Schema

  alias __MODULE__

  import Ecto.Changeset

  schema "user" do
    field(:player_name, :string)
    field(:hashed_password, :string)
    field(:password, :string, virtual: true)
    field(:current_pos_x, :float)
    field(:current_pos_y, :float)
    field(:current_pos_z, :float)
    field(:create_time, :utc_datetime)
    field(:is_valid, :boolean)
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:player_name, :password])
    |> validate_required([:player_name, :password])
    |> unique_constraint(:player_name)
    |> put_hashed_password()
  end

  @spec default_attrs() :: %{
          create_time: DateTime.t(),
          current_pos_x: 0,
          current_pos_y: 0,
          current_pos_z: 0,
          is_valid: true
        }
  def default_attrs() do
    %{
      current_pos_x: 0,
      current_pos_y: 0,
      current_pos_z: 0,
      is_valid: true,
      create_time: DateTime.utc_now()
    }
  end

  @spec auth(FreddieTest.Model.User.t(), binary()) :: boolean()
  def auth(%User{hashed_password: hashed_password}, password) do
    Bcrypt.verify_pass(password, hashed_password)
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
