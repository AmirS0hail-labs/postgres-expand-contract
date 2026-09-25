class UserPhonesController < ApplicationController
  def create
    UserPhone.create!(
      user_id: params[:user_id],
      phone: params[:phone],
      is_primary: false
    )
    redirect_to root_path
  rescue ActiveRecord::ActiveRecordError => error
    redirect_to root_path, alert: error.message
  end
end
