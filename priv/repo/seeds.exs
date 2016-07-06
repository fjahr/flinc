alias Flinc.{Repo, User}

[
  %{
    name: "John Doe",
    email: "john@flinc.com",
    password: "12345678"
  },
]
|> Enum.map(&User.changeset(%User{}, &1))
|> Enum.each(&Repo.insert!(&1))
