class UserPhonesController < ApplicationController
  include HighlightsPerson

  def create
    phone = UserPhone.create!(
      user_id: params[:user_id],
      phone: params[:phone],
      is_primary: false
    )
    highlight_and_redirect(phone.user_id, "secondary", phone: phone)
  rescue ActiveRecord::ActiveRecordError => error
    redirect_record_error(error)
  end
end
