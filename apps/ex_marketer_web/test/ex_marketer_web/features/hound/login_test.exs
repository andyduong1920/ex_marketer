defmodule ExMarketerWeb.Hound.LoginTest do
  use ExMarketerWeb.FeatureCaseHound

  hound_session()

  test "login", _meta do
    user = insert(:user)

    login(user.email)

    assert find_element(:tag, "body") |> has_class?("app-layout")
    assert find_element(:tag, "nav") |> visible_text =~ "Welcome, " <> user.email
  end

  test "online users", _meta do
    user_1 = insert(:user)
    user_2 = insert(:user)
    user_3 = insert(:user)

    login(user_1.email)
    in_browser_session(:user_2_session, fn -> login(user_2.email) end)
    in_browser_session(:user_3_session, fn -> login(user_3.email) end)

    assert_online_users(user_1, user_2, user_3)
    in_browser_session(:user_2_session, fn -> assert_online_users(user_1, user_2, user_3) end)
    in_browser_session(:user_3_session, fn -> assert_online_users(user_1, user_2, user_3) end)

    assert find_element(:css, ".notification .alert") |> visible_text =~
             "#{user_3.email} just login"

    in_browser_session(:user_2_session, fn ->
      assert find_element(:css, ".notification .alert") |> visible_text =~
               "#{user_3.email} just login"
    end)

    in_browser_session(:user_3_session, fn ->
      assert {:error, _} = search_element(:css, ".notification .alert")
    end)
  end

  defp login(email) do
    navigate_to(Routes.user_session_url(ExMarketerWeb.Endpoint, :new))

    find_element(:id, "user_email") |> fill_field(email)
    find_element(:id, "user_password") |> fill_field(valid_user_password())
    find_element(:css, ".btn.btn-primary") |> submit_element
  end

  defp assert_online_users(user_1, user_2, user_3) do
    assert find_element(:css, ".online-user .badge-success") |> visible_text == "3"
    assert find_element(:css, ".online-user .dropdown-menu") |> inner_text =~ user_1.email
    assert find_element(:css, ".online-user .dropdown-menu") |> inner_text =~ user_2.email
    assert find_element(:css, ".online-user .dropdown-menu") |> inner_text =~ user_3.email
  end
end
