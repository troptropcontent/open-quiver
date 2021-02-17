class BoardsController < ApplicationController
  def index
    @boards = policy_scope(Board).order(created_at: :desc)
  end

  def filter
    @boards = Board.category(params[:category])
    authorize @boards
    array = []
    @boards.each do |board|
      array << board.as_json.merge({"image"=>board.photo.key})
    end
    render json: array.to_json
  end

  def show
    @board = Board.find(params[:id])
    authorize @board
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      redirect_to board_path(@board)
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
    @board.destroy
    redirect_to boards_path
  end

  private

  def board_params
    params.require(:board).permit(:name, :brand, :length, :thickness, :width, :volume, :price,
    :longitude, :latitude, :status)
  end
end
