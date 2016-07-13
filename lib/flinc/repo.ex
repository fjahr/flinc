  defmodule Flinc.Repo do
    use Ecto.Repo, otp_app: :flinc
    use Scrivener, page_size: 10
  end
