class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
    @users = User.all
    @book = Book.new
  end

  def show
    @book_new = Book.new
    @user = User.find(params[:id])
    @books =Book.where(user_id: @user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user_id = current_user.id
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully.."
      redirect_to user_path(@user.id)
    else
     render "edit"
   end
 end

 private

 def user_params
  params.require(:user).permit(:name, :introduction, :profile_image)
end
def book_params
  params.require(:book).permit(:title, :body)
end
def ensure_correct_user
  if current_user.id != params[:id].to_i
    flash[:notice] = "権限がありません"
    redirect_to user_path(current_user.id)
  end
end
end
