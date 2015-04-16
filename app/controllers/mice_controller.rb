class MiceController < ApplicationController
  before_action :set_mouse, only: [:show, :edit, :update, :destroy, :change_status]

  def list
    @mice = Mouse.by_family_id(params[:family_id]).page(params[:page]).per(PER_PAGE)
    render action: :index
  end

  def show
  end

  def new
    @mouse = Mouse.new
  end

  def edit
  end

  def create
    @mouse = Mouse.new(mouse_params)

    respond_to do |format|
      if @mouse.save
        format.html { redirect_to @mouse, notice: 'Mouse was successfully created.' }
        format.json { render :show, status: :created, location: @mouse }
      else
        format.html { render :new }
        format.json { render json: @mouse.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @mouse.update(mouse_params)
        format.html { redirect_to @mouse, notice: 'Mouse was successfully updated.' }
        format.json { render :show, status: :ok, location: @mouse }
      else
        format.html { render :edit }
        format.json { render json: @mouse.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mouse.destroy
    respond_to do |format|
      format.html { redirect_to mice_url, notice: 'Mouse was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_status
    return redirect_to action: :index if params[:status].nil?
    @mouse.status = params[:status]
    @mouse.save
    if params[:family_id].nil?
      return redirect_to action: :index
    else
      return redirect_to action: :list, family_id: params[:family_id]
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mouse
      @mouse = Mouse.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mouse_params
      params.require(:mouse).permit(:family_id, :sex_id, :sequence_id, :status)
    end
end
