class ReservesController < ApplicationController
  before_action :set_reserve, only: [:destroy]

  def index
    @reserves = Reserve.all
  end

  def destroy
    @reserve.destroy
    respond_to do |format|
      format.html { redirect_to reserves_url, notice: "予約は削除されました" }
    end
  end

  private

  def set_reserve
    @reserve = Reserve.find(params[:id])
  end
end
