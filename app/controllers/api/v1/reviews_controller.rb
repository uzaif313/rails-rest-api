class Api::V1::ReviewsController < ApplicationController
  include Authenticate
  before_action :load_book, only: :index
  before_action :load_review, only: [:show, :update]
  before_action :authenticate_with_token!, only: :create
  def index
    @reviews = @book.reviews
    json_response "List of Reviews", true, { reviews: @reviews }, :ok
  end

  def show
    json_response "Detail of Reviews", true,{ review: @review }, :ok
  end

  def create
    @review = current_user.reviews.build(permit_review_params)
    if @review.save
      json_response "Book Save added", true, { review: @review }, :ok
      else
      json_response "Something goes wrong", false, { error:@review.errors }, :ok
    end
  end

  def update
    if authorized? @review.user
      if @review
    else
      json_response 'Why you want to peep on other person review',false,{}, :unauthorized
    end
  end

  def destroy
  end

  private

    def load_book
      @book = Book.find_by(id:params[:id])
      unless @book.present?
        json_response "Unable to find book", false, {}, :not_found
      end
    end

    def load_review
      @review = Review.find_by(id:params[:id])
      unless @review.present?
        json_response "Unable to find Reviews", false, {}, :not_found
      end
    end

    def permit_review_params
      params.require(:review).permit(:title, :content_rating, :recommend_rating, :book_id)
    end
end
