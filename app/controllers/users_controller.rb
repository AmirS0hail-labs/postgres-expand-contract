class UsersController < ApplicationController
  include HighlightsPerson

  def index
    @people = PersonCard.list(replay)
  end

  def create
    user = OldUser.create!(name: params[:name], phone: params[:phone])
    highlight_and_redirect(user.id, "primary")
  rescue ActiveRecord::ActiveRecordError => error
    redirect_record_error(error)
  end

  def update
    user = OldUser.find(params[:id])
    user.update!(phone: params[:phone])
    highlight_and_redirect(user.id, "primary")
  rescue ActiveRecord::ActiveRecordError => error
    redirect_record_error(error)
  end

  private

  def replay
    PersonCard::Replay.new(
      kind: flash[:highlight].to_s,
      user_id: flash[:highlight_id].to_i,
      phone_id: flash[:highlight_phone_id].to_i
    )
  end
end
