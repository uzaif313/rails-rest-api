class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :image
            #  :avg_rating_of_book, :content_rating_of_book, :recommend_rating_of_book,
            #  :total_review
  has_many :reviews

  def avg_rating_of_book
    object.reviews.count == 0 ? 0 : object.reviews.average(:average_rating).round(1)
  end

  def content_rating_of_book
    object.reviews.count == 0 ? 0 : object.reviews.average(:content_rating).round(1)
  end

  def recommend_rating_of_book
    object.reviews.count == 0 ? 0 : object.reviews.average(:recommend_rating).round(1)
  end

  def total_review
    object.reviews_count
  end
end
