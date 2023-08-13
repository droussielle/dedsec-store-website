
// Fetch list of products
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
            <img src=${image_url} alt="img" class="rounded" id="product-${id}-img">
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

        <div class="float-end d-none" id="quantity-${id}-container">
            <span>Qty: </span>
            <button id="down-${id}" class="btn btn-primary m-0 py-0" onclick="this.parentNode.querySelector('input[type=number]').stepDown()">-</button>

            <input id="quantity-${id}" style="width: 50px;" min="0" max="${quantity}" name="quantity" value="1" type="number"/>
            
            <button id="up-${id}" class="btn btn-primary m-0 py-0" onclick="this.parentNode.querySelector('input[type=number]').stepUp()">+</button>
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

async function Load_Product_List(){

    let products = await Get_Product_List();
    let product_container = document.getElementById('Products-Container');

    for(let i = 0; i < products.length; i++){

        let current_item = products[i];
        let id = current_item['id'];
        let name = current_item['name'];
        let image_url = current_item['image_url'];
        let price = current_item['price'];

        let short_description = current_item['short_description'];
        short_description = short_description.split('\r\n');
        short_description = short_description.filter(feature => feature.trim() !== '');

        // Generate Product templates
        let product_template = generateItem(id, name, image_url, price, short_description)

        // Append to Products-container
        product_container.appendChild(product_template);
    }

    return products;
}

document.addEventListener('DOMContentLoaded', async ()=>{
    
    let products = await Load_Product_List();
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

        let id = childrens[i].id;
        let img = childrens[i].querySelector(`#product-${id}-img`);
        let btn = childrens[i].querySelector(`#product-${id}-btn`);
        let qty_label = childrens[i].querySelector(`#quantity-${id}`);
        let qty_container = childrens[i].querySelector(`#quantity-${id}-container`);

        img.addEventListener('click', ()=>{

            localStorage.setItem('get_detail', id);
            window.location.href = '/pages/product-details.php';

        });

        // If add to cart is clicked
        btn.addEventListener('click', async ()=>{

            if(btn.classList.contains('d-none')) return;

            // // add to cart
            // const res = await fetch(`http://localhost:8000/product/${id}`,{
            //     headers: {
            //         'Authorization': `Bearer ${get_token()}`
            //     },
            //     body: `{
            //         "quantity": 1
            //     }
            //     `
            // })

            // let data = await res.json(); //Fix later
            
            // Exchange btn
            btn.classList.add('d-none');
            qty_container.classList.remove('d-none');
        });

        qty_container.addEventListener('click', async (event)=>{
            
            if(qty_container.classList.contains('d-none')) return;
            if(event.target.tagName !== 'BUTTON' && event.target.tagName !== 'INPUT') return;

            let current_qty = parseInt(qty_label.value);


            if (current_qty === 0){
                // Exchange btn
                qty_container.classList.add('d-none');
                btn.classList.remove('d-none');
                qty_label.value = '1';
            }
        });
        
        

    }

});
