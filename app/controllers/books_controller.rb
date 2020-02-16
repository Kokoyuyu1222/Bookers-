class BooksController < ApplicationController
  before_action :authenticate_user!

  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}


  def index
    @books =Book.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id

    @books = Book.all
    if @book.save
     flash[:notice] = "You have creatad book successfully."
     redirect_to book_path(@book.id)
   else
     render "index"
        end
 end


 def show
   @book_new = Book.new
   @book = Book.find(params[:id])
   @user = User.find(@book.user_id)
 end

 def edit
   @book = Book.find(params[:id])
 end

 def update
   @book = Book.find(params[:id])
   @book.user_id = current_user.id
   if @book.update(book_params)
     flash[:notice] = "You have updated book successfully."
     redirect_to book_path
   else
     render "edit"
   end
 end

 def destroy
   book = Book.find(params[:id])
   book.destroy
   redirect_to books_path
 end
 private

 def book_params
  params.require(:book).permit(:title, :body)
end
def user_params
  params.require(:user).permit(:name, :introduction, :profile_image)
end
def ensure_correct_user
  @book = Book.find_by(id: params[:id])
  if current_user.id != @book.user_id
    flash[:notice] = "権限がありません"
    redirect_to books_path
  end
end
end
