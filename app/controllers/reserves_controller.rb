class ReservesController < ApplicationController
  before_action :set_reserve, only: [:destroy]

  def index
    @reserves = Reserve.page(params[:page]).per(PER_PAGE)
    @male_count = {}
    @female_count = {}
    @reserves.each do |reserve|
      @male_count[reserve.id] = 0
      @female_count[reserve.id] = 0
      reserve.mice.each do |mouse|
        @male_count[reserve.id] += 1 if mouse.sex.male?
        @female_count[reserve.id] += 1 if mouse.sex.female?
      end
    end
  end

  def new
    @mice = Mouse.by_family_id(params[:family_id])
  end

  def create
    @mouse_ids = params[:mouse_ids]
    if @mouse_ids.blank?
      flash[:error] = "少なくとも1匹以上指定してください"
      return redirect_to action: :new 
    end
    Mouse.where(id: @mouse_ids).update_all(status: :reserved)
    @family_id = Mouse.find(@mouse_ids.first).family.id
    @reserve = Reserve.new({user_id:     current_user.id,
                            family_id:   @family_id,
                            mouse_ids:   @mouse_ids,
                            use_at:      params[:use_at],
                            reserved_at: Time.current
    })

    if @reserve.save!
      flash[:notice] = "予約が完了しました"
      redirect_to action: :index
    else
      flash[:error] = "予約に失敗しました"
      redirect_to action: :new, family_id: @family_id
    end
    
  end

  def destroy
    Mouse.where(id: @reserve.mouse_ids).update_all(status: :available)
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
