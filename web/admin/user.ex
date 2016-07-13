defmodule Flinc.ExAdmin.User do
  use ExAdmin.Register

  register_resource Flinc.User do
    index do
      selectable_column

      column :id
      column :name
      column :email
      actions
    end

  end
end
