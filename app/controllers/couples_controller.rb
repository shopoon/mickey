class CouplesController < ApplicationController
  before_action :set_couple, only: [:update_status, :destroy]

  def index
    @couples = Couple.page(params[:page]).per(PER_PAGE)
  end

  def new
  end

  def register
    if params[:count].blank?
      flash[:error] = "交配数を入力してください。"
      return redirect_to action: :new
    end
    @count = params[:count].to_i
    @genotype = params[:genotype]
    
    @families = Family.by_genotype(@genotype)
    
    @mother_candidates = []
    @father_candidates = []
    @families.each do |family|
      family.mice.waiting.each do |mouse|
        if mouse.sex.male?
          @father_candidates << [mouse.display_name, mouse.id]
        else
          @mother_candidates << [mouse.display_name, mouse.id]
        end
      end
    end

    if @father_candidates.size < @count || @mother_candidates.size < @count
      flash[:alert] = "繁殖用マウスが不足してます。<br />繁殖用マウスを設定してください。"
      return redirect_to controller: :mice
    end
  end

  def create
    if params[:couples].blank?
      return redirect_to invalid_error_index_path
    end
    return redirect_to action: :new if params[:couples].blank?
    Couple.transaction do
      params[:couples].each do |id, hash|
        mother = Mouse.find(hash["mother_id"])
        father = Mouse.find(hash["father_id"])
        @couple = Couple.new({
          mother_id: mother.id,
          father_id: father.id,
          mated_at: hash["mated_at"],
        })
        @couple.save!

        mother.update_status(:mating)
        father.update_status(:mating)
      end     
    end
    flash[:notice] = 'Couple was successfully registered!'
    return redirect_to action: :index
  rescue => e
    flash[:error] = @couple.errors.full_messages.join('<br />')
    return redirect_to action: :new
  end

  def update_status
    return redirect_to action: :index if params[:status].nil?
    @couple.update_attributes(status: params[:status])
    redirect_to action: :index
  end

  def destroy
    Couple.transaction do
      @couple.father.update_status(:waiting)
      @couple.mother.update_status(:waiting)
      @couple.destroy
    end
    flash[:notice] = 'Couple was successfully destroyed.'
    redirect_to action: :index
  rescue => e
    raise e
  end

  private
    def set_couple
      @couple = Couple.find(params[:id])
    end
end
