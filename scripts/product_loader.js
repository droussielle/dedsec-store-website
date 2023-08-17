const category_id_list = {
    'all': '',
    "laptops": '?category_id=1',
    "tablets": '?category_id=2',
    "accessories": '?category_id=3',
    "raspberry-pis": '?category_id=4'
}

// Fetch list of products
async function Get_Product_List(category_id = ''){
    const res = await fetch(`http://localhost:8000/product${category_id}`,{
        method: 'GET'
    });
    let data = await res.json();
    data = data['data'];

    return data;
}

// Sort by price
function Product_List_Sorted(products, sort_id){

    if(sort_id === 'default') return products;

    if(sort_id === 'price-low-high'){

        products.sort((a, b) =>{
            return parseFloat(a.price) - parseFloat(b.price);
        });
    }
    else if(sort_id === 'price-high-low'){

        products.sort((b, a) =>{
            return parseFloat(a.price) - parseFloat(b.price);
        });
    }

    return products;
}

function get_token(){

    if(!(localStorage.getItem('user'))){
        alert("Please login to use this features");
        window.location.href='/pages/sign.php'
        return '';
    }
    return JSON.parse(localStorage.getItem('user')).token;
}

async function access_current_cart(myToken){

    const res = await fetch(`http://localhost:8000/cart`,{
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${myToken}`
        },
    });

    let data = await res.json();

    return {status: res.ok, message: data.message};
}

async function update_current_cart(myToken, id, quantity){

    const res = await fetch(`http://localhost:8000/cart/product/${id}`,{
        method: 'PATCH',
        headers: {
            'Authorization': `Bearer ${myToken}`
        },
        body: `{
            "quantity": "${quantity}"
        }
        `
    });

    let data = await res.json();

    return {status: res.ok, message: data.message};
}

async function add_to_cart(myToken, id, quantity = 1){

    const res = await fetch(`http://localhost:8000/cart/product/${id}`,{
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${myToken}`
        },
        body: `{
            "quantity": ${quantity}
        }
        `
    });

    let data = await res.json();
    return {status: res.ok, message: data.message};
}

async function delete_from_cart(myToken, id){

    const res = await fetch(`http://localhost:8000/cart/product/${id}`,{
        method: 'DELETE',
        headers: {
            'Authorization': `Bearer ${myToken}`
        },
    });

    let data = await res.json();
    return {status: res.ok, message: data.message};
}



function get_label_quantity(i, id){
    let qty_label = document.querySelector(`#quantity-${id}`);
    return parseInt(qty_label.value);
}

////////////////// FORMAT PRODUCT ////////////////////
function generateItem(id, name, image_url, price, short_description, quantity){
    
    // image_url = '/images/product_Laptop13.png' //Static img for testing purpose
    // Init list features
    var list_features = ''
    for (i in short_description){
        list_features += `<li class="fb">${short_description[i]}</li>`
    }

    // Create template
    var product_template = document.createElement('div');
    product_template.className = 'col-lg-10 col-sm-12 card border-0 border-bottom border-dark rounded-0 bg-light mb-3';
    product_template.id = `${id}`;

    var product_body = `
    <div class="row">

        <div class="col-md-2 col-4">
            <img src=${image_url} alt="img" class="rounded img-fluid" id="product-${id}-img">
        </div>

        <div class="col-md-10 col-8">
            <div class="card-body pt-0">
                <div class="d-md-flex justify-content-md-between">
                    <h5 class="card-titles fb" id="product-${id}-name">${name}</h5>
                    <span class="fb fw-bolder" id="product-${id}-price">$${price}</span>
                </div>
                
                <ul class="features" id = "product-${id}-short_description">
                    ${list_features}
                </ul>
            </div>
        </div>

    </div>
    <div class="mb-3 mt-0 col-md-10 offset-md-2">

        <div class="float-end ms-4 d-none" id="quantity-${id}-container">
            <!-- <span>Qty: </span> -->
            <button id="down-${id}" class="btn btn-primary m-0 py-0" onclick="this.parentNode.querySelector('input[type=number]').stepDown()">-</button>

            <input id="quantity-${id}" style="width: 50px;" min="0" max="${quantity}" name="quantity" value="1" type="number"/>
            
            <button id="up-${id}" class="btn btn-primary m-0 py-0" onclick="this.parentNode.querySelector('input[type=number]').stepUp()">+</button>
            
            <button id="update-${id}" class="btn btn-success m-0 ms-3 py-1 px-2 d-inline-flex align-items-center">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cart4" viewBox="0 0 16 16">
                    <path d="M0 2.5A.5.5 0 0 1 .5 2H2a.5.5 0 0 1 .485.379L2.89 4H14.5a.5.5 0 0 1 .485.621l-1.5 6A.5.5 0 0 1 13 11H4a.5.5 0 0 1-.485-.379L1.61 3H.5a.5.5 0 0 1-.5-.5zM3.14 5l.5 2H5V5H3.14zM6 5v2h2V5H6zm3 0v2h2V5H9zm3 0v2h1.36l.5-2H12zm1.11 3H12v2h.61l.5-2zM11 8H9v2h2V8zM8 8H6v2h2V8zM5 8H3.89l.5 2H5V8zm0 5a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0zm9-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0z"/>
                </svg>
            </button>

        </div>

        <div class="float-end p-0 m-0">
            <button type="button" class="btn btn-primary m-0 align-content-end align-self-end" id="product-${id}-btn">Add to cart</button>
        </div>

    </div>
    `
    
    // <div class="align-self-end  align-content-end p-0 m-0"><button type="button" class="btn btn-primary m-0 mb-3 align-content-end align-self-end" id="product-${id}-btn">Add to cart</button></div>
    // `
    product_template.innerHTML = product_body;

    return product_template;

    // Append to Products-container
    // var product_container = document.getElementById('Products-Container');
    // product_container.appendChild(product_template);

}

async function Load_Product_List(category_id, sort_id){

    // Filter product list
    let products = await Get_Product_List(category_id);
    products = Product_List_Sorted(products ,sort_id);

    // Get the product container
    let product_container = document.getElementById('Products-Container');
    product_container.innerHTML = '';

    for(let i = 0; i < products.length; i++){

        let current_item = products[i];
        let id = current_item['id'];
        let name = current_item['name'];
        let image_url = current_item['image_url'];
        let price = current_item['price'];

        let short_description = current_item['short_description'];
        short_description = short_description.split('\n');
        short_description = short_description.filter(feature => feature.trim() !== '');

        // Generate Product templates
        let product_template = generateItem(id, name, image_url, price, short_description)

        // Append to Products-container
        product_container.appendChild(product_template);
    }

    return products;
}

// Handle cart
async function Page_load_with_filer(category_id, sort_id){

    let products = await Load_Product_List(category_id, sort_id);
    let product_results = document.getElementById('product-results');

    if (products.length <= 1){
        product_results.innerText = `${products.length} result`;
    } else {
        product_results.innerText = `${products.length} results`;
    }
    
    // If User click on the image, it will jump to product-detail page
    let product_container = document.getElementById('Products-Container');
    const childrens = product_container.children;

    for (let i = 0; i < childrens.length; i++){

        // Get product html element's infor
        let id = childrens[i].id;
        let img = childrens[i].querySelector(`#product-${id}-img`);
        let btn = childrens[i].querySelector(`#product-${id}-btn`);
        let qty_label = childrens[i].querySelector(`#quantity-${id}`);
        let qty_container = childrens[i].querySelector(`#quantity-${id}-container`);
        let update_cart = childrens[i].querySelector(`#update-${id}`);

        img.addEventListener('click', ()=>{

            localStorage.setItem('get_detail', id);
            window.location.href = '/pages/product-details.php';

        });

        // If add to cart is clicked
        btn.addEventListener('click', async ()=>{

            // Add to cart button is not displaying!
            if(btn.classList.contains('d-none')) return;

            //Checking logged in
            const myToken = get_token(); 

            //Access to cart first
            const access_to_cart = await access_current_cart(myToken); 
            //--> Failed to access
            if(!(access_to_cart.status)){
                alert(access_to_cart.message);
                return;
            }

            // Add to cart
            const add_cart = await add_to_cart(myToken, id, 1); //Can adjust quantity
            alert(add_cart.message);
            //--> Failed to add to cart
            //if(!(add_cart.status)) return;

            
            // Exchange btn
            btn.classList.add('d-none');
            qty_container.classList.remove('d-none');
        });

        // Update product in cart
        update_cart.addEventListener('click', async ()=>{
            
            // Add to cart button is not clicked
            if(qty_container.classList.contains('d-none')) return;
            
            let current_qty = parseInt(qty_label.value);

            //Checking logged in
            const myToken = get_token(); 

            //Access to cart first
            const access_to_cart = await access_current_cart(myToken); 
            //--> Failed to access
            if(!(access_to_cart.status)){
                alert(access_to_cart.message);
                return;
            }

            //Update user's cart
            const update_cart = await update_current_cart(myToken, id, current_qty);
            alert(update_cart.message);
            //--> Failed to update cart
            //if(!(update_cart.status)) return;

            if (current_qty === 0){

                // Delete from cart
                const del_cart = await delete_from_cart(myToken, id);
                alert(del_cart.message);

                // Exchange btn
                qty_container.classList.add('d-none');
                btn.classList.remove('d-none');
                qty_label.value = '1';
            }
        });
        
    }
}

function change_checked_radio(radio_id, sort_id){
    document.getElementById(radio_id).checked = true;
    document.getElementById(sort_id).checked = true;
}

// Page loaded
document.addEventListener('DOMContentLoaded', async ()=>{
    
    let category_id;
    let sort_id;

    if(!localStorage.getItem('filter-products')){
        category_id = '';
        sort_id = 'default';
    }
    else{
        category_id = JSON.parse(localStorage.getItem('filter-products')).category_id;
        sort_id = JSON.parse(localStorage.getItem('filter-products')).sort_id;

        change_checked_radio(category_id, sort_id);
        category_id = category_id_list[category_id];
    }

    let loading = await Page_load_with_filer(category_id,sort_id);
});


// Listen to Filter button
document.querySelector('#filter-btn').addEventListener('click', async()=>{

    // Get all the radio buttons
    const radioButtons = document.querySelectorAll('#categories-dropdown input[type="radio"]');
    const sort_by = document.querySelectorAll('#sortby-dropdown input[type="radio"]');

    let category_id;
    let sort_id;
    // Add event listeners to each radio button
    radioButtons.forEach((radioButton) => {

        if (radioButton.checked) {
            category_id = radioButton.id;
            return;
        }
    });

    sort_by.forEach((radioButton) => {

        if (radioButton.checked) {
            sort_id = radioButton.id;
            return;
        }
    });

    localStorage.setItem('filter-products', JSON.stringify({category_id: category_id, sort_id: sort_id}));

    category_id = category_id_list[category_id];
    let loading = await Page_load_with_filer(category_id, sort_id);

})


