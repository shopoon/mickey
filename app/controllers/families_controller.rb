class FamiliesController < ApplicationController
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  before_filter :set_since
  before_filter :set_until

  def index
    if params[:genotype]
      families = Family.where(genotype: params[:genotype])
     
      if @since || @until
        families = families.where("birth >= ? and birth <= ?", @since, @until)
      end
      @families = []
      families.each do |family|
        case params[:sex]
        when "male"
          @families.push(family) if family.male_count > 0
        when "female"
          @families.push(family) if family.female_count > 0
        else
          @families.push(family)
        end
      end
    else
      @families = Family.all
    end
    @families = Kaminari.paginate_array(@families).page(params[:page]).per(PER_PAGE)
  end

  def new
  end

  def register
    return redirect_to action: :new if params[:genotype].nil? || params[:count].to_i <= 0
    @count = params[:count].to_i
    @genotype = params[:genotype]
    @latest_number = Family.latest_number_with_genotype(@genotype)
  end
  
  def create
    return redirect_to action: :new if params[:families].blank? || params[:mice].blank?
    Mouse.transaction do
      params[:families].each do |id, hash|
        @family = Family.new(hash)
        @family.save!

        if params[:mice][id][:male_count].present?
          (1..params[:mice][id][:male_count].to_i).each do |count|
            @mice = Mouse.new({family_id: @family.id,
                               sex: :male,
                               sequence_id: count,
                               status: :available,
            })
            @mice.save!
          end
        end
        if params[:mice][id][:female_count].present?
          (1..params[:mice][id][:female_count].to_i).each do |count|
            @mice = Mouse.new({family_id: @family.id,
                               sex: :female,
                               sequence_id: count,
                               status: :available,
            })
            @mice.save!
          end
        end
      end
    end
    return redirect_to :action => :index, notice: 'Family was successfully registered!'
  rescue => e
    raise e
  end

  def edit
  end

  def show
  end

  def update
    respond_to do |format|
      if @family.update(family_params)
        format.html { redirect_to @family, notice: 'Family was successfully updated.' }
        format.json { render :show, status: :ok, location: @family }
      else
        format.html { render :edit }
        format.json { render json: @family.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Family.transaction do
      @family.mice.destroy_all
      @family.destroy
    end
    flash[:notice] = "Family was successfully destroyed."
    redirect_to families_url
  end

  private
    def set_family
      @family = Family.find(params[:id])
    end

    def family_params
      params.require(:family).permit(:number, :genotype, :birth, :parent_id)
    end

end
