require 'sequel'

db = nil

def initialize_database(production)
  if production
    db = Sequel.connect ENV['DATABASE_URL']
  else
    db = Sequel.connect 'sqlite://data.db'
  end

  begin
    db.create_table :students do
      primary_key :id
      String :name
      String :city
      Float :gps_lat  # N
      Float :gps_lon  # W
    end
  rescue Sequel::DatabaseError
    # TODO: there's a better way to create a table only if it doesn't exist
  end
end
