module HighlightsPerson
  extend ActiveSupport::Concern

  private

  def highlight_and_redirect(user_id, kind, phone: nil)
    flash[:highlight] = kind
    flash[:highlight_id] = user_id
    remember_phone(phone) if phone
    redirect_to root_path
  end

  def remember_phone(phone)
    flash[:highlight_phone] = phone.phone.to_s
    flash[:highlight_phone_id] = phone.id
  end

  def redirect_record_error(error)
    redirect_to root_path, alert: error.message
  end
end
