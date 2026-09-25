class UsersController < ApplicationController
  def index
    @old_users = OldUser.order(:id)
    @new_users = NewUser.order(:id).includes(:user_phones)
  end

  def create
    OldUser.create!(name: params[:name], phone: params[:phone])
    redirect_to root_path
  rescue ActiveRecord::ActiveRecordError => error
    redirect_to root_path, alert: error.message
  end

  def update
    user = OldUser.find(params[:id])
    user.update!(phone: params[:phone])
    redirect_to root_path
  rescue ActiveRecord::ActiveRecordError => error
    redirect_to root_path, alert: error.message
  end
end
