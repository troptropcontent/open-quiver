class BoardsController < ApplicationController
  def index
    @categories = Board::CATEGORY
    @boards = policy_scope(Board).order(created_at: :desc)
  end

  def filter
    @boards = params[:board_category] == "all" ? Board.all : Board.select_categories(params[:board_category].split(','))
    @boards = @boards.near(params[:place], 100)  if params[:place]
    authorize @boards
    array = []
    @boards.each do |board|
      array << board.as_json.merge({"image"=>board.photo.key})
    end
    render json: array.to_json
  end

  def show
    @board = Board.find(params[:id])
    @reservation = Reservation.new
    @review = Review.new
    authorize @reservation
    gon.board_reservations = @board.reservations
    authorize @board
  end

  def new
    @board = Board.new
    authorize @board
  end

  def create
    @board = Board.new(board_params)
    authorize @board
    @board.user = current_user
    if @board.save
      redirect_to dashboard_path, alert: "Your listing has been made successfully!"
    else
      render 'new'
    end
  end

  def edit
    @board = Board.find(params[:id])
  end

  def update
    @board = Board.find(params[:id])
    @board.update(board_params)
    redirect_to board_path(@board)
  end

  def destroy
    @board = Board.find(params[:id])
    authorize @board
    @board.destroy
    redirect_to dashboard_path
  end

  private

  def board_params
    params.require(:board).permit(:name, :brand, :length, :thickness, :width, :volume, :price,
    :city, :zipcode, :street, :photo, :status, :category)
  end
end
