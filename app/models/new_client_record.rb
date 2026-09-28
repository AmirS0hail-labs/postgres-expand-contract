class NewClientRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to database: { writing: :new, reading: :new }

  def self.connection
    use_search_path(super, Pgroll.new_search_path)
  end

  def self.use_search_path(connection, search_path)
    connection.schema_search_path = search_path
    connection
  end

  private_class_method :use_search_path
end
