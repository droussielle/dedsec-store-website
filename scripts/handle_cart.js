// Fetch list of cart products
async function Get_Product_List(){

    const res = await fetch('http://localhost:8000/product');
    let data = await res.json();
    data = data['data'];

    return data;
}

async function Get_Single_Product(id){

    const res = await fetch(`http://localhost:8000/product/${id}`,{
        method: 'GET',
    });

    let data = await res.json();
    return {status: res.ok, message: data.message, data: data.data};
}

function get_token(){

    if(!(localStorage.getItem('user'))){
        alert("Please login to use this features");
        window.location.href='/pages/sign.php'
        return '';
    }
    return JSON.parse(localStorage.getItem('user')).token;
}

async function get_current_cart(myToken){

    const res = await fetch(`http://localhost:8000/cart`,{
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${myToken}`
        },
    });

    let data = await res.json();

    return {status: res.ok, message: data.message, data: data.data};
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

function get_label_quantity(id){
    let qty_label = document.querySelector(`#quantity-${id}`);
    return parseInt(qty_label.value);
}

function set_label_quantity(id, quantity){
    let qty_label = document.querySelector(`#quantity-${id}`);
    qty_label.value = `${quantity}`;
    return;
}

//////////////---FORMAT ITEM---////////////////
function generateItem(id, name, image_url, price, short_description, quantity){
    
    // image_url = '/images/product_Laptop13.png' //Static img for testing purpose
    // Init list features
    var features = `${short_description}`;

    // Create template
    var product_template = document.createElement('div');
    product_template.className = 'col-lg-10 col-sm-12 card border-0 border-bottom border-dark rounded-0 bg-light mb-3 pe-0';
    product_template.id = `${id}`;

    var product_body = `

    <div class="row">

        <div class="col-md-2 col-4">
            <img class="img-fluid rounded" src="${image_url}" alt="img" id="product-${id}-img">
        </div>

        <div class="col-md-10 col-8">
            <div class="pt-0 p-0">

                <div class="d-md-flex justify-content-md-between">
                    <h5 class="fb me-2" id="product-${id}-name">${name}</h5>
                    <span class="fb fw-bolder" id="product-${id}-price">$${price}</span>
                </div>
                
                <div class="features" id = "product-${id}-short_description">
                    ${features}
                </div>
                
            </div>
        </div>

    </div>

    <div class="my-3 col-md-10 offset-md-2" id="quantity-${id}-container">

        <div class="float-start">
            <span>Qty: </span>
            <button id="down-${id}" class="btn btn-primary m-0 py-0" onclick="this.parentNode.querySelector('input[type=number]').stepDown()">-</button>

            <input id="quantity-${id}" style="width: 50px;" min="0" name="quantity" value="${quantity}" type="number"/>
            
            <button id="up-${id}" class="btn btn-primary m-0 py-0" onclick="this.parentNode.querySelector('input[type=number]').stepUp()">+</button>

            <button id="update-${id}" class="btn btn-success m-0 ms-3 py-1 px-2 d-inline-flex align-items-center">
                <svg id="update-${id}-svg" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cart4" viewBox="0 0 16 16">
                    <path id="update-${id}-path" d="M0 2.5A.5.5 0 0 1 .5 2H2a.5.5 0 0 1 .485.379L2.89 4H14.5a.5.5 0 0 1 .485.621l-1.5 6A.5.5 0 0 1 13 11H4a.5.5 0 0 1-.485-.379L1.61 3H.5a.5.5 0 0 1-.5-.5zM3.14 5l.5 2H5V5H3.14zM6 5v2h2V5H6zm3 0v2h2V5H9zm3 0v2h1.36l.5-2H12zm1.11 3H12v2h.61l.5-2zM11 8H9v2h2V8zM8 8H6v2h2V8zM5 8H3.89l.5 2H5V8zm0 5a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0zm9-1a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm-2 1a2 2 0 1 1 4 0 2 2 0 0 1-4 0z"/>
                </svg>
            </button>
        </div>

        <a style="float:right;">
            <img id="product-${id}-bin-icon" src="/images/cart_bin-icon.png" alt="bin-icon">
        </a>

    </div>
    `
    
    product_template.innerHTML = product_body;

    return product_template;

}


async function Load_Product_List(){

    const myToken = get_token();
    let products_cart = await get_current_cart(myToken);

    // If cannot get cart list
    if(!(products_cart.status)){
        alert(products_cart.message);
        return;
    }
    // Get cart list
    let products = products_cart.data.items;
    let product_container = document.getElementById('Products-Container');
    product_container.innerHTML = '';

    for(let i = 0; i < products.length; i++){

        let current_item = products[i];
        let id = current_item['product_id'];
        let name = current_item['product_name'];
        let image_url = current_item['product_image'];
        let price = current_item['total_price'];

        let short_description = `
        DMA Ryzen™ 7 7840U (8c/16t, up to 5.1GHz) | 
        64GB DDR5-5600 (2x32) | 4TB WW_BLACK™ SN850X | 
        Radeon™ 700M Graphics | 80Wh | Fedora Workstation 38
        `
        let get_this_product = await Get_Single_Product(id);
        short_description = get_this_product.data['short_description'];

        let quantity = current_item['quantity'];

        // Generate Product templates
        let product_template = generateItem(id, name, image_url, price, short_description, quantity)

        // Append to Products-container
        product_container.appendChild(product_template);
    }

    return products;
}

async function update_cart(){

    let product_container = document.getElementById('Products-Container');
    let childs = product_container.children;

    let delivery = document.getElementById('delivery');
    let subtotal = document.getElementById('subtotal');
    let estimated_tax = document.getElementById('estimated-tax');
    let shipping = document.getElementById('shipping');
    let total_price = document.getElementById('total-price');

    // Date
    let today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    delivery_date = mm + '/' + dd + '/' + yyyy;

    // Others
    let subtotal_value = 0.00;
    let estimated_tax_value = 0.00;
    let shipping_value = 0.00;
    let total = 0;

    // Total
    const myToken = get_token();
    let current_cart = await get_current_cart(myToken);
    if(current_cart.status) total = current_cart.data.total;
    total = parseFloat(total);
    total = total.toFixed(2);

    delivery.textContent = `${delivery_date}`;
    subtotal.textContent = `$${subtotal_value}`;
    estimated_tax.textContent = `$${estimated_tax_value}`;
    shipping.textContent = `$${shipping_value}`;
    total_price.textContent = `$${total}`;

    let load_again = await Load_Product_List();

    if(childs.length === 0){
        product_container.innerHTML = `
            Your cart is empty <a class="fb fw-bold" href="/pages/product.php">Go shopping now ></a> 
        `
    }

    return;
}

document.addEventListener('DOMContentLoaded', async ()=>{
    
    let product = await Load_Product_List();
    const myToken = get_token();
    let product_container = document.getElementById('Products-Container');

    update_cart();

    product_container.addEventListener('click', async (event) =>{

        let clickedElement = event.target;

        // Check if the clicked element is the remove button
        let remove_id = /product-(\d+)-bin-icon/;
        if (clickedElement.id.match(remove_id)){

            
            let this_child_id = clickedElement.id.match(/\d+/);
            this_child_id = parseInt(this_child_id[0]);
            let this_child = document.getElementById(`${this_child_id}`);

            // Remove from cart
            let remove_cart = await delete_from_cart(myToken, this_child_id);

            alert(remove_cart.message);
            // --> Failed to remove
            if(!(remove_cart.status)) return;


            // Remove this HTML from cart
            product_container.removeChild(this_child);
            update_cart();

            return;
        }

        //Check if click btn down-up
        let btn_update = /update-(\d+)/;
        let btn_update_svg = /update-(\d+)-svg/;
        let btn_update_path = /update-(\d+)-path/;

        if (clickedElement.id.match(btn_update) || clickedElement.id.match(btn_update_svg) || clickedElement.id.match(btn_update_path)){

            let this_child_id = clickedElement.id.match(/\d+/);
            this_child_id = parseInt(this_child_id[0]);

            let current_quantity = get_label_quantity(this_child_id);
            let updating_Mycart = await update_current_cart(myToken, this_child_id, current_quantity);

            alert(updating_Mycart.message);
            // --> Failed to update
            // if(!(updating_Mycart.status)) return;

            // Remove this HTML from cart
            if(current_quantity === 0){

                // Remove from cart
                let remove_cart = await delete_from_cart(myToken, this_child_id);

                alert(remove_cart.message);
                // --> Failed to remove
                if(!(remove_cart.status)) return;

                // Remove this HTML from cart
                let this_child = document.getElementById(`${this_child_id}`);
                product_container.removeChild(this_child);
            }
            update_cart();

            return;
        }

        

    });

});

document.getElementById('cart-continue').addEventListener('click', async()=>{

    const myToken = get_token();
    let current_cart = await get_current_cart(myToken);
    if(current_cart.status && current_cart.data.items.length > 0){
        window.location.href = '/pages/checkout.php';
    } else {

        if(current_cart.status && current_cart.data.items.length <= 0){
            alert('No items in your cart, go shopping now');
        } else {
            alert(current_cart.message);
        }
    }

    return;
    
});