class ReservationsController < ApplicationController

  def new
    @board = Board.find(params[:board_id])
    @reservation = Reservation.new
    authorize @reservation
    gon.board_reservations = @board.reservations
  end

  def create
    @board = Board.find(params[:board_id])
    @reservation = Reservation.new(reservation_params)
    authorize @reservation
    @reservation.board = @board
    @reservation.user = current_user
    if @reservation.save
      redirect_to board_path(@board)
    else
      render :new
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end

end
