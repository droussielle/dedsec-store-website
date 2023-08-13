document.getElementById('cart-continue').addEventListener('click', ()=>{
    window.location.href = '/pages/checkout.php';
});

// Fetch list of cart products
async function Get_Product_List(){

    const res = await fetch('http://localhost:8000/product');
    let data = await res.json();
    data = data['data'];

    return data;
}

function get_token(){
    const data = JSON.stringify(localStorage.getItem('user')).data;
    if (data){
        return data.token;
    }
    return '';
}

function generateItem(id, name, image_url, price, short_description, quantity = 5){
    
    image_url = '/images/product_Laptop13.png' //Static img for testing purpose
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

            <input id="quantity-${id}" style="width: 50px;" min="0" max="${quantity}" name="quantity" value="1" type="number"/>
            
            <button id="up-${id}" class="btn btn-primary m-0 py-0" onclick="this.parentNode.querySelector('input[type=number]').stepUp()">+</button>
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

    let products = await Get_Product_List();
    let product_container = document.getElementById('Products-Container');

    for(let i = 0; i < products.length; i++){

        let current_item = products[i];
        let id = current_item['id'];
        let name = current_item['name'];
        let image_url = current_item['image_url'];
        let price = current_item['price'];

        // let short_description = current_item['short_description'];
        let short_description = `
        DMA Ryzen™ 7 7840U (8c/16t, up to 5.1GHz) | 
        64GB DDR5-5600 (2x32) | 4TB WW_BLACK™ SN850X | 
        Radeon™ 700M Graphics | 80Wh | Fedora Workstation 38
        `

        // let quantity = current_item['quantity'];
        let quantity = 5;

        // Generate Product templates
        let product_template = generateItem(id, name, image_url, price, short_description, quantity)

        // Append to Products-container
        product_container.appendChild(product_template);
    }

    return products;
}

function update_cart(){

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
    for(let i=0; i < childs.length; i++){

        let id = childs[i].id;

        // Get price
        let price = childs[i].querySelector(`#product-${id}-price`).textContent;
        price = price.match(/\d+\.\d+/g);
        price = parseFloat(price[0]);

        // Get qty
        let qty = childs[i].querySelector(`#quantity-${id}`).value;
        qty = parseInt(qty);

        total += price*qty;

    }

    total = total.toFixed(2);

    delivery.textContent = `${delivery_date}`;
    subtotal.textContent = `$${subtotal_value}`;
    estimated_tax.textContent = `$${estimated_tax_value}`;
    shipping.textContent = `$${shipping_value}`;
    total_price.textContent = `$${total}`;

    if(childs.length === 0){
        product_container.innerHTML = `
            Your cart is empty <a class="fb fw-bold" href="/pages/product.php">Go shopping now ></a> 
        `
    }

    return;
}

document.addEventListener('DOMContentLoaded', async ()=>{
    
    let product = await Load_Product_List();
    // If User click on the image, it will jump to product-detail page
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

            // Use fetch API to remove from cart
            product_container.removeChild(this_child);
            update_cart();

            return;
        }

        //Check if click btn down-up
        let btn_down = /down-(\d+)/;
        let btn_up = /up-(\d+)/;

        if (clickedElement.id.match(btn_down) || clickedElement.id.match(btn_up)){

            let this_child_id = clickedElement.id.match(/\d+/);
            this_child_id = parseInt(this_child_id[0]);

            let input_value = document.querySelector(`#quantity-${this_child_id}`);
            if(parseInt(input_value.value) === 0){

                let this_child = document.getElementById(`${this_child_id}`);
                // Use fetch API to remove from cart
                product_container.removeChild(this_child);
                update_cart();

                return;
            }

            update_cart();

        }

        

    });

});