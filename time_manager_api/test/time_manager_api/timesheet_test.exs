defmodule TimeManagerApi.TimesheetTest do
  use TimeManagerApi.DataCase

  alias TimeManagerApi.Timesheet

  describe "workingtimes" do
    alias TimeManagerApi.Timesheet.WorkingTime

    import TimeManagerApi.TimesheetFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert Timesheet.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Timesheet.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2024-10-07 13:03:00], end: ~N[2024-10-07 13:03:00]}

      assert {:ok, %WorkingTime{} = working_time} = Timesheet.create_working_time(valid_attrs)
      assert working_time.start == ~N[2024-10-07 13:03:00]
      assert working_time.end == ~N[2024-10-07 13:03:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timesheet.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~N[2024-10-08 13:03:00], end: ~N[2024-10-08 13:03:00]}

      assert {:ok, %WorkingTime{} = working_time} = Timesheet.update_working_time(working_time, update_attrs)
      assert working_time.start == ~N[2024-10-08 13:03:00]
      assert working_time.end == ~N[2024-10-08 13:03:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Timesheet.update_working_time(working_time, @invalid_attrs)
      assert working_time == Timesheet.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Timesheet.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Timesheet.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Timesheet.change_working_time(working_time)
    end
  end
end
