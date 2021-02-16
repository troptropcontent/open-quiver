class BoardsController < ApplicationController
  def index
    @boards = policy_scope(Board).order(created_at: :desc)
  end
  
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
