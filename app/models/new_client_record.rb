class NewClientRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :new, reading: :new }

  def self.connection
    conn = super
    conn.schema_search_path = Pgroll.new_search_path
    conn
  end
end
