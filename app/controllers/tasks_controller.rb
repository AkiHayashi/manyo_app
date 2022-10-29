class TasksController < ApplicationController
  before_action :correct_user, only: %i[show edit update]

  PER_PAGE = 10

  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    tasks = current_user.tasks.all
    tasks = search_tasks(tasks).page(params[:page]).per(PER_PAGE)

    @tasks = if params[:sort_deadline_on] == 'true'
              tasks.order_by_deadline_on.order_by_created_at
            elsif params[:sort_priority] == 'true'
              tasks.order_by_priority.order_by_created_at
            else
              tasks.order_by_created_at
            end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.new(task_params)
    label_ids = params[:task][:label_ids]
    if label_ids.present?
      label_ids.each do |label_id|
        @task.task_labels.new(label_id: label_id)
      end
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path, notice: t('.created') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @task.labels.destroy_all
    label_ids = params[:task][:label_ids]
    if label_ids.present?
      label_ids.each do |label_id|
        @task.task_labels.new(label_id: label_id)
      end
    end

    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: t('.updated') }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: t('.destroyed') }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def search_tasks(tasks)
    return tasks if params[:search].nil?

    tasks = search_by_title(tasks)
    tasks = search_by_status(tasks)
    tasks = search_by_label_id(tasks)
    tasks
  end

  def search_by_title(tasks)
    return tasks if params[:search][:title].blank?

    tasks.search_by_title(params[:search][:title])
  end

  def search_by_status(tasks)
    return tasks if params[:search][:status].blank?

    tasks.search_by_status(params[:search][:status].to_sym)
  end

  def search_by_label_id(tasks)
    return tasks if params[:search][:label_id].blank?

    tasks.search_by_label_id(params[:search][:label_id].to_i)
  end

  def correct_user
    user = Task.find(params[:id]).user
    redirect_to tasks_path, notice: 'アクセス権限がありません' unless current_user?(user)
  end
end
