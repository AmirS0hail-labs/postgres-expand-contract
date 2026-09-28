class PersonCard
  Replay = Data.define(:kind, :user_id, :phone_id)

  def self.list(replay)
    phones_by_user = UserPhone.order(:id).group_by(&:user_id)

    OldUser.order(id: :desc).map do |user|
      new(user: user, phones: phones_by_user[user.id] || [], replay: replay)
    end
  end

  def initialize(user:, phones:, replay:)
    @user = user
    @phones = order_phones(phones)
    @replay = replay
  end

  attr_reader :user, :phones

  def primary_phone
    phones.find(&:is_primary)
  end

  def extra_phones
    phones.reject(&:is_primary)
  end

  def phone_text
    user.phone.to_s
  end

  def copied_text
    primary_phone ? primary_phone.phone.to_s : phone_text
  end

  def replay_mode
    replaying? ? replay.kind : ""
  end

  def appearing?(phone)
    replay_mode == "secondary" && phone.id == replay.phone_id
  end

  private

  attr_reader :replay

  def order_phones(phones)
    phones.sort_by { |phone| [phone.is_primary ? 0 : 1, phone.id] }
  end

  def replaying?
    replay.user_id == user.id
  end
end
