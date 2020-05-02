defmodule ReverseWeb.WordLiveTest do
  use ReverseWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Reverse.Words

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  defp fixture(:word) do
    {:ok, word} = Words.create_word(@create_attrs)
    word
  end

  defp create_word(_) do
    word = fixture(:word)
    %{word: word}
  end

  describe "Index" do
    setup [:create_word]

    test "lists all words", %{conn: conn, word: word} do
      {:ok, _index_live, html} = live(conn, Routes.word_index_path(conn, :index))

      assert html =~ "Listing Words"
      assert html =~ word.body
    end

    test "saves new word", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      assert index_live |> element("a", "New Word") |> render_click() =~
        "New Word"

      assert_patch(index_live, Routes.word_index_path(conn, :new))

      assert index_live
             |> form("#word-form", word: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#word-form", word: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.word_index_path(conn, :index))

      assert html =~ "Word created successfully"
      assert html =~ "some body"
    end

    test "updates word in listing", %{conn: conn, word: word} do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      assert index_live |> element("#word-#{word.id} a", "Edit") |> render_click() =~
        "Edit Word"

      assert_patch(index_live, Routes.word_index_path(conn, :edit, word))

      assert index_live
             |> form("#word-form", word: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#word-form", word: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.word_index_path(conn, :index))

      assert html =~ "Word updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes word in listing", %{conn: conn, word: word} do
      {:ok, index_live, _html} = live(conn, Routes.word_index_path(conn, :index))

      assert index_live |> element("#word-#{word.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#word-#{word.id}")
    end
  end

  describe "Show" do
    setup [:create_word]

    test "displays word", %{conn: conn, word: word} do
      {:ok, _show_live, html} = live(conn, Routes.word_show_path(conn, :show, word))

      assert html =~ "Show Word"
      assert html =~ word.body
    end

    test "updates word within modal", %{conn: conn, word: word} do
      {:ok, show_live, _html} = live(conn, Routes.word_show_path(conn, :show, word))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Word"

      assert_patch(show_live, Routes.word_show_path(conn, :edit, word))

      assert show_live
             |> form("#word-form", word: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#word-form", word: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.word_show_path(conn, :show, word))

      assert html =~ "Word updated successfully"
      assert html =~ "some updated body"
    end
  end
end
