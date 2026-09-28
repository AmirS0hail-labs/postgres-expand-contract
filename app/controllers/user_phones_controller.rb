class UserPhonesController < ApplicationController
  def create
    phone = UserPhone.create!(
      user_id: params[:user_id],
      phone: params[:phone],
      is_primary: false
    )
    flash[:highlight] = "secondary"
    flash[:highlight_id] = phone.user_id
    flash[:highlight_phone] = phone.phone.to_s
    flash[:highlight_phone_id] = phone.id
    redirect_to root_path
  rescue ActiveRecord::ActiveRecordError => error
    redirect_to root_path, alert: error.message
  end
end
