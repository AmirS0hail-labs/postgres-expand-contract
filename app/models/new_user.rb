class NewUser < NewClientRecord
  self.table_name = "users"
  self.primary_key = "id"
  self.record_timestamps = false

  has_many :user_phones, foreign_key: :user_id, inverse_of: :user
end
