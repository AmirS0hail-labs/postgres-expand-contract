class UsersController < ApplicationController
  def index
    phones_by_user = UserPhone.order(:id).group_by(&:user_id)
    @people = OldUser.order(id: :desc).map do |user|
      { user: user, phones: phones_by_user[user.id] || [] }
    end
  end

  def create
    user = OldUser.create!(name: params[:name], phone: params[:phone])
    flash[:highlight] = "primary"
    flash[:highlight_id] = user.id
    redirect_to root_path
  rescue ActiveRecord::ActiveRecordError => error
    redirect_to root_path, alert: error.message
  end

  def update
    user = OldUser.find(params[:id])
    user.update!(phone: params[:phone])
    flash[:highlight] = "primary"
    flash[:highlight_id] = user.id
    redirect_to root_path
  rescue ActiveRecord::ActiveRecordError => error
    redirect_to root_path, alert: error.message
  end
end
