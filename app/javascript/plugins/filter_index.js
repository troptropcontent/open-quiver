import { initMapbox } from '../plugins/init_mapbox';

const filterIndex = () => {
  const update_list = (data) => {
    boards.innerHTML = '';
    let markers = []
    data.forEach((board) => {
      markers.push({
        lat: board.latitude,
        lng: board.longitude,
      });
      boards.insertAdjacentHTML('beforeend', `

      <div class="card-board">
      <div class="card-board-infos">

        <a href="/boards/${board.id}"><h2>${board.name}</h2></a>
        <p>dims : ${board.length} X ${board.width} X ${board.thickness}-${board.volume}</p>
        <p>${board.category}</p>
      </div>
      <img src="http://res.cloudinary.com/dn9jutvov/image/upload/${board.image}" />
      </div>
      `);
    });
    console.log(JSON.stringify(markers))
    map.dataset.markers = JSON.stringify(markers)
    initMapbox();
  };

  const filter = (e) => {
    console.log(e)
    console.log(e["board_category"])
    console.log(e["place"])
    console.log(`http://localhost:3000/search?board_category=${e["board_category"]}&place=${e["place"]}`)
    fetch(`http://localhost:3000/search?board_category=${e["board_category"]}&place=${e["place"]}`)
    
      .then(response => response.json())
      .then(data => update_list(data));
  };
  

  console.log("Hello from app/javascript/packs/application.js!");
  const volume = document.getElementById("volume") 
  volume.addEventListener("input", (e) => {
    var rangeVal = $('#volume').val()
    $('#showval').html(rangeVal)
  })
  
  console.log("boards uploaded.")
  const boards = document.querySelector('.boards')
  const map = document.getElementById('map')
  const category = document.getElementById('board_category');
  const place = document.getElementById('place');
  filter( {"board_category" : "all", "place" : place.value });

  if ((category) && (boards)) {
    category.addEventListener("change", (event) => { console.log(event.target.value)
    console.log(event.target.value === "")
    const querry = {"board_category" : category.value , "place" : place.value }
    filter(querry)
    });
  }
}






export { filterIndex }
