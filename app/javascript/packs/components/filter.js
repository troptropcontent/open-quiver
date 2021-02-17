const filterIndex = () => {
  const update_list = (data) => {
    boards.innerHTML = '';
    data.forEach((board) => {
      boards.insertAdjacentHTML('beforeend', `
  
      <div class="card-product">
      <div class="card-product-infos">
        <a href="/boards/${board.id}"><h2>${board.name}</h2></a>
        <p>dims : ${board.length} X ${board.width} X ${board.thickness}-${board.volume}</p>
        <p>${board.category}</p>
      </div>
      <img src="http://res.cloudinary.com/dn9jutvov/image/upload/${board.image}" />
      </div>      
      `);
    });
  };
  
  const filter = (e) => {
    fetch(`http://localhost:3000/search/category/${e}`)
      .then(response => response.json())
      .then(data => update_list(data));
  };
  
  console.log("Hello from app/javascript/packs/application.js!");
  filter("");
  console.log("boards uploaded.")
  const boards = document.querySelector('.boards')
  const category = document.getElementById('board_category');
  
  
  category.addEventListener("change", (event) => { console.log(event.target.value)
  console.log(event.target.value === "")
  filter(event.target.value)
  
  });
}

export { filterIndex }