
// Data
id_list = {
    'laptop13': {
        'src': './img/Laptop13.png',
        'price': '9999.00',
        'features': [
            'Extremely modular design with upgradable components',
            'Comes with DMA Ryzen™ 7040 Series and 13th Gen ENTEL®',
            'Out-of-box compatibility with most Linux distros'
        ],
    },
}

let id = 'laptop13'
let product_current = id_list[id];
let pro_src = product_current['src']
let pro_price = product_current['price'];
let pro_features = product_current['features'];

function generateItem(id_code = id, src = pro_src, price=pro_price, features=pro_features){
    
    var product_container = document.getElementById('Products-Container');

    // Init list features
    var list_features = ''
    for (i in features){
        list_features += `<li class="fb">${features[i]}</li>`
    }

    // Create template
    var product_template = document.createElement('div');
    product_template.className = 'col-lg-10 col-sm-12 card border-0 border-bottom border-dark rounded-0 bg-light mb-3';
    product_template.id = id_code;

    var product_body = `
    <div class="row">

        <div class="col-md-2 col-4">
            <img src=${src} alt="img" class="rounded">
        </div>

        <div class="col-md-10 col-8">
            <div class="card-body pt-0">
                <div class="d-md-flex justify-content-md-between">
                    <h5 class="card-titles fb" id="product-name-price">DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series)</h5>
                    <span class="fb fw-bolder">$${price}</span>
                </div>
                
                <ul class="features">
                    ${list_features}
                </ul>
            </div>
        </div>

    </div>
    <div class="align-self-end  align-content-end p-0 m-0"><button type="button" class="btn btn-primary m-0 mb-3 align-content-end align-self-end">Add to cart</button></div>
    `
    product_template.innerHTML = product_body;
    product_container.appendChild(product_template);

}
