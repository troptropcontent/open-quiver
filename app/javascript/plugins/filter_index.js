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
          <div class="card-board-infos-top">
            <a href="/boards/${board.id}"><h2>${board.name}</h2></a>
            <p>dims : ${board.length} X ${board.width} X ${board.thickness}-${board.volume}</p>
          </div>
          <div class="card-board-infos-bottom">
            <p>${board.category.split('/')[0]}</p>
            <p>${Math.round(board.price * 100) / 100} € / kiff </p>
          </div>
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
    console.log(e["board_categories"])
    console.log(e["place"])
    console.log(`http://localhost:3000/search?board_category=${e["board_categories"]}&place=${e["place"]}`)
    fetch(`http://localhost:3000/search?board_category=${e["board_categories"]}&place=${e["place"]}`)
    
      .then(response => response.json())
      .then(data => update_list(data));
  };


  console.log("Hello from app/javascript/packs/application.js!");
  // const volume = document.getElementById("volume") 
  // volume.addEventListener("input", (e) => {
  //   var rangeVal = $('#volume').val()
  //   $('#showval').html(rangeVal)
  // })
  
  console.log("boards uploaded.")

  const submit_button = document.querySelector('.btn.btn-gradient')

  if (submit_button) {
    submit_button.addEventListener("click", (event)=>{
      event.preventDefault();
      filter(generateQuery());
  
    });
  }

  const check_boxes = document.querySelectorAll('.cat-buttons > input,.all-button > input')
  
  const cat_checkboxes = document.querySelectorAll('.cat-buttons > input') 

  const all_cat_checkboxes = document.querySelector('.all-button > input') 

  if (all_cat_checkboxes) {
    all_cat_checkboxes.addEventListener("change",(event)=>{

      console.log(event.target.checked);
      if (event.target.checked) {
        cat_checkboxes.forEach(check_box => {check_box.checked = false});
      }
      filter(generateQuery());
    });
  }

  cat_checkboxes.forEach((checkBox)=>{

      checkBox.addEventListener("change", (event)=>{
        console.log(event.target.checked);
        if (event.target.checked) {
          all_cat_checkboxes.checked = false
        };
        filter(generateQuery());
      });
  

  });







  const boards = document.querySelector('.boards')
  const map = document.getElementById('map')
  const category = document.getElementById('board_category');
  const check_boxes_category = document.querySelectorAll("#categories_")

  check_boxes_category.forEach(check_box => {
    check_box.addEventListener("change", (event) => {
    console.log(event.target.checked);
    console.log("box checked array below")
    console.log(Object.values(box_checked()))
    console.log("box checked array above")
    filter(generateQuery());
    });
    
  });
  ;
 if (all_cat_checkboxes) {
  filter(generateQuery());
 }

  if ((category) && (boards)) {
    category.addEventListener("change", (event) => { console.log(event.target.value)
    console.log(event.target.value === "")
    const querry = {"board_category" : category.value , "place" : place.value }
    filter(querry)
    });
  }
}
const place = document.getElementById('query')
const box_checked = () => {
  // return document.querySelectorAll('#categories_:checked')
  return Array.from(document.querySelectorAll('.cat-buttons > input:checked,.all-button > input:checked')).map((box)=>{return box.defaultValue})
};
const generateQuery = () => {
const boxes_checked = box_checked()
return {"board_categories" : boxes_checked, "place" : place.value }

};



export { filterIndex }
