class ReviewSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :content_rating, :recommend_rating, :average_rating, :review_image
  belongs_to :user
  belongs_to :book

  def review_image
    rails_blob_path(object.image) if object.image.attachment
  end
end
