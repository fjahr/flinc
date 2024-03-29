defmodule Flinc.BoardChannel.MonitorTest do
  use ExUnit.Case, async: true

  import Flinc.Factory

  alias Flinc.BoardChannel.Monitor

  @board_id "1-board"

  setup_all do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Flinc.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Flinc.Repo, {:shared, self()})

    users = %{
      first_user: insert(:user),
      second_user: insert(:user),
      third_user: insert(:user)
    }

    Monitor.create(@board_id)

    {:ok, %{users: users}}
  end

  test "it adds a user calling :user_joined", %{users: users} do
    Monitor.user_joined(@board_id, users.first_user.id)
    Monitor.user_joined(@board_id, users.second_user.id)
    new_state = Monitor.user_joined(@board_id, users.third_user.id)

    assert new_state == [users.third_user.id, users.second_user.id, users.first_user.id]
  end

  test "it removes a user when calling :user_left", %{users: users} do
    Monitor.user_joined(@board_id, users.first_user.id)
    Monitor.user_joined(@board_id, users.second_user.id)
    new_state = Monitor.user_joined(@board_id, users.third_user.id)
    assert new_state == [users.third_user.id, users.second_user.id, users.first_user.id]

    new_state = Monitor.user_left(@board_id, users.third_user.id)
    assert new_state == [users.second_user.id, users.first_user.id]

    new_state = Monitor.user_left(@board_id, users.second_user.id)
    assert new_state == [users.first_user.id]
  end

  test "it returns the list of users in channel when calling :users_in_board", %{users: users} do
    Monitor.user_joined(@board_id, users.first_user.id)
    Monitor.user_joined(@board_id, users.second_user.id)
    Monitor.user_joined(@board_id, users.third_user.id)

    returned_users = Monitor.users_in_board(@board_id)

    assert returned_users === [users.third_user.id, users.second_user.id, users.first_user.id]
  end
end
