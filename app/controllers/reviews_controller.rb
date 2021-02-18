class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def create
    @review = Review.new(review_params)
    if @review.save!
      redirect_to review_path(@review)
    else
      render 'new'
    end
  end

  def review_params
    puts 'inside params'
    params.require(:review).permit(:name)
  end

end
