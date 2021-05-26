Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      Integer :external_id, index: true
      String :first_name
      String :last_name
      Integer :age
    end
  end
end