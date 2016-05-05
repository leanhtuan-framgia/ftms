class Admin::CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :load_data, except: [:index, :show, :destroy]

  def index
    @courses = (current_user.is_admin? ? @courses.recent : current_user.courses)
    respond_to do |format|
      format.html {add_breadcrumb t("breadcrumbs.courses.all")}
      format.json {
        render json: CoursesDatatable.new(view_context)
      }
    end
  end

  def new
    @course.documents.build
    add_breadcrumb_courses
    add_breadcrumb_course_new
  end

  def edit
    add_breadcrumb_courses
    add_breadcrumb @course.name, :admin_course_path
    add_breadcrumb t("breadcrumbs.courses.edit")
  end

  def create
    if @course.save
      flash[:success] = flash_message "created"
      redirect_to admin_courses_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = flash_message "updated"
      redirect_to admin_course_path(@course)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def show
    @course_subjects = @course.course_subjects
    @users = @course.users
    @trainers = @course.users.trainers
    @trainees = @course.users.trainees

    add_breadcrumb_courses
    add_breadcrumb @course.name, :admin_course_path
  end

  def destroy
    if @course.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to admin_courses_path
  end

  private
  def course_params
    params.require(:course).permit Course::COURSE_ATTRIBUTES_PARAMS
  end

  def load_data
    @subjects = Subject.all
    @programming_languages = ProgrammingLanguage.all
  end
end
