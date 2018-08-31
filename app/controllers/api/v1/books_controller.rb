class Api::V1::BooksController < ApplicationController
  before_action :load_book, only: :show

  def index
    @books = Book.all
    json_response "List Of Books",true, serailie_json(@books), :ok
  end

  def show
    json_response "Detail of Book", true, serailie_json(@book), :ok
  end

  private
    def load_book
      @book = Book.find_by(id:params[:id])
      unless @book.present?
        json_response "Book Not found", false, {}, :not_found
      end
    end
end
