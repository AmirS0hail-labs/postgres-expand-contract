class OldClientRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :old, reading: :old }

  def self.connection
    use_search_path(super, Pgroll.old_search_path)
  end

  def self.use_search_path(connection, search_path)
    connection.schema_search_path = search_path
    connection
  end

  private_class_method :use_search_path
end
