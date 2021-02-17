class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def create
    @reviews = Review.new(reviews_params)
    if @reviews.save
      redirect_to reviews_path(@reviews)
    else
      render 'new'
    end
  end

  def reviews_params
    params.require(:reviews).permit(:name)
  end

end
