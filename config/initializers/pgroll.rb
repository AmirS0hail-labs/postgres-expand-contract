module Pgroll
  CONFIG = YAML.safe_load_file(Rails.root.join("config/pgroll.yml")).freeze

  def self.url
    CONFIG.fetch("url")
  end

  def self.old_search_path
    CONFIG.fetch("old_search_path")
  end

  def self.new_search_path
    CONFIG.fetch("new_search_path")
  end
end
