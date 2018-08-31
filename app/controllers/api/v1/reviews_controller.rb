class Api::V1::ReviewsController < ApplicationController
  include Authenticate
  before_action :load_book, only: [:index, :create, :update]
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: :create

  def index
    @reviews = @book.reviews
    json_response "List of Reviews", true, {reviews: serailie_json(@reviews)}, :ok
  end

  def show
    json_response "Detail of Reviews", true, {review: serailie_json(@review)}, :ok
  end

  def create
    @review = current_user.reviews.build(permit_review_params)
    @review.book = @book
    if @review.save
      json_response "Book Save added", true, {review: serailie_json(@review)}, :ok
    else
      json_response "Something goes wrong", false, {error: @review.errors}, :ok
    end
  end

  def update
    if authorized? @review.user
      if @review.update permit_review_params
        json_response "Updated review successfully", true, {review: serailie_json(@review)}, :ok
      else
        json_response "unable to update review", false, {}, :unproccessable_entity
      end
    else
      json_response "Why you want to peep on other person review", false, {}, :unauthorized
    end
  end

  def destroy
    if authorized? @review.user
      if @review.destroy
        json_response "destroy review successfully", true, {review: serailie_json(@review)}, :ok
      else
        json_response "unable to destroy review", false, {}, :unproccessable_entity
      end
    else
      json_response "Why you want to peep on other person review", false, {}, :unauthorized
    end
  end

  private

  def load_book
    @book = Book.find_by(id: params[:book_id])
    unless @book.present?
      json_response "Unable to find book", false, {}, :not_found
    end
  end

  def load_review
    @review = Review.find_by(id: params[:id])
    unless @review.present?
      json_response "Unable to find Reviews", false, {}, :not_found
    end
  end

  def permit_review_params
    params.require(:review).permit(:title, :content_rating, :recommend_rating, :book_id)
  end
end
