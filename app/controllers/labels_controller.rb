class LabelsController < ApplicationController
  before_action :set_label, only: %i[edit update destroy]

  # GET /Labels or /Labels.json
  def index
    @labels = current_user.labels.all
  end

  # GET /Labels/new
  def new
    @label = current_user.labels.new
  end

  # GET /Labels/1/edit
  def edit
  end

  # POST /Labels or /Labels.json
  def create
    @label = current_user.labels.new(label_params)

    respond_to do |format|
      if @label.save
        format.html { redirect_to labels_path, notice: 'ラベルを登録しました' }
        format.json { render :show, status: :created, location: @Label }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @Label.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Labels/1 or /Labels/1.json
  def update
    respond_to do |format|
      if @label.update(label_params)
        format.html { redirect_to labels_path, notice: 'ラベルを更新しました' }
        format.json { render :show, status: :ok, location: @label }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1 or /labels/1.json
  def destroy
    @label.destroy

    respond_to do |format|
      format.html { redirect_to labels_path, notice: 'ラベルを削除しました' }
      format.json { head :no_content }
    end
  end

  private
  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
