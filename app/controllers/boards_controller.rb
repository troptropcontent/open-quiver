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
  # https://res.cloudinary.com/dn9jutvov/image/upload/jha3u8tkbu8ho2xeb9b0qc80rxeu
  def new
    @boards = Board.new
  end

  def create
    @boards = Board.new(board_params)
    if @boards.save
      redirect_to board_path(@boards)
    else
      render 'new'
    end
  end

  def edit
    @boards = Board.find(params[:id])
  end

  def update
    @boards = Board.find(params[:id])
    @boards.update(params[:board])
    redirect_to board_path(@boards)
  end

  def destroy
    @boards = Board.find(params[:id])
    @boards.destroy
  end

  def show
    @boards = Board.find(params[:id])
  end

  def board_params
    params.require(:boards).permit(:name)
  end
end
