defmodule ExMarketer.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def unique_user_email, do: "user#{System.unique_integer()}@example.com"
      def valid_user_password, do: "hello world!"

      def user_factory do
        %ExMarketer.Accounts.User{
          email: unique_user_email(),
          hashed_password: Bcrypt.hash_pwd_salt(valid_user_password())
        }
      end

      def extract_user_token(fun) do
        {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
        [_, token, _] = String.split(captured.body, "[TOKEN]")
        token
      end
    end
  end
end
