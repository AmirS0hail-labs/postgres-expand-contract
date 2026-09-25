class OldClientRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :old, reading: :old }

  def self.connection
    conn = super
    conn.schema_search_path = Pgroll.old_search_path
    conn
  end
end
