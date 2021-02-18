class ReservationsController < ApplicationController

  def index
    @revervations = Reservation.all
  end

  def create
    @board = Board.find(params[:board_id])
    @reservation = Reservation.new(reservation_params)
    authorize @reservation
    @reservation.board = @board
    @reservation.user = current_user
    if @reservation.save
      redirect_to dashboard_path, alert: "Your reservation has been made successfully!"
    else
      render :new
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    authorize @reservation
    @reservation.destroy
    redirect_to dashboard_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end

end
