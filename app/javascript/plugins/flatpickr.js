import flatpickr from "flatpickr";
import rangePlugin from "flatpickr/dist/plugins/rangePlugin";

const listReservations = gon.board_reservations;
const array = [];

gon.board_reservations.forEach((reservation) => {
  var hash = {
    from: reservation.start_date,
    to: reservation.end_date
  };
  array.push(hash)
})

flatpickr("#range_start", {
  altInput: true,
  disable: array,
  dateFormat: "Y-m-d",
  plugins: [new rangePlugin({ input: "#range_end"})]
});
