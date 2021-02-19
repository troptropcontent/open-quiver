class ReviewsController < ApplicationController
  def index
    @rating = Review::RATING
    @reviews = Review.all
  end

  def create
    @review = Review.new(review_params)
    authorize @review
    @review.reservation_id = params["reservation_id"]
    @review.user = current_user
    if @review.save!
      redirect_to dashboard_path
    else
      redirect_to dashboard_path
    end
  end

  def destroy
    @review = Review.find(params[:id])
    authorize @review
    @review.destroy
    redirect_to dashboard_path
  end

  def review_params
    puts 'inside params'
    params.require(:review).permit(:name, :rating, :content)
  end

end
