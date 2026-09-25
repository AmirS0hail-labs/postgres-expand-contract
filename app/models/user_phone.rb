class UserPhone < NewClientRecord
  self.table_name = "user_phones"
  self.primary_key = "id"
  self.record_timestamps = false

  belongs_to :user, class_name: "NewUser", foreign_key: :user_id, inverse_of: :user_phones
end
