Sequel.migration do
  change do
    create_table(:sessions) do
      primary_key :id
      foreign_key :user_id, :users
      Integer :external_id, index: true
      Integer :external_user_id
      Integer :duration, index: true
      String :browser_name, index: true
      String :browser_version, index: true
      Date :visited_at
    end
  end
end