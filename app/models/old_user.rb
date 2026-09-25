class OldUser < OldClientRecord
  self.table_name = "users"
  self.primary_key = "id"
  self.record_timestamps = false
end
