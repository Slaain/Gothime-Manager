defmodule TimeManagerApiWeb.OrganisationControllerTest do
  use TimeManagerApiWeb.ConnCase

  import TimeManagerApi.OrganisationManagerFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all organisations", %{conn: conn} do
      conn = get(conn, ~p"/organisations")
      assert html_response(conn, 200) =~ "Listing Organisations"
    end
  end

  describe "new organisation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/organisations/new")
      assert html_response(conn, 200) =~ "New Organisation"
    end
  end

  describe "create organisation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/organisations", organisation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/organisations/#{id}"

      conn = get(conn, ~p"/organisations/#{id}")
      assert html_response(conn, 200) =~ "Organisation #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/organisations", organisation: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Organisation"
    end
  end

  describe "edit organisation" do
    setup [:create_organisation]

    test "renders form for editing chosen organisation", %{conn: conn, organisation: organisation} do
      conn = get(conn, ~p"/organisations/#{organisation}/edit")
      assert html_response(conn, 200) =~ "Edit Organisation"
    end
  end

  describe "update organisation" do
    setup [:create_organisation]

    test "redirects when data is valid", %{conn: conn, organisation: organisation} do
      conn = put(conn, ~p"/organisations/#{organisation}", organisation: @update_attrs)
      assert redirected_to(conn) == ~p"/organisations/#{organisation}"

      conn = get(conn, ~p"/organisations/#{organisation}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, organisation: organisation} do
      conn = put(conn, ~p"/organisations/#{organisation}", organisation: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Organisation"
    end
  end

  describe "delete organisation" do
    setup [:create_organisation]

    test "deletes chosen organisation", %{conn: conn, organisation: organisation} do
      conn = delete(conn, ~p"/organisations/#{organisation}")
      assert redirected_to(conn) == ~p"/organisations"

      assert_error_sent 404, fn ->
        get(conn, ~p"/organisations/#{organisation}")
      end
    end
  end

  defp create_organisation(_) do
    organisation = organisation_fixture()
    %{organisation: organisation}
  end
end
