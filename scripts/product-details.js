function get_token(){

    if(!(localStorage.getItem('user'))){
        alert("Please login to use this features");
        window.location.href='/pages/sign.php'
        return '';
    }
    return JSON.parse(localStorage.getItem('user')).token;
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

// Fetch list of products
async function Get_Product_Single(id){
    const res = await fetch(`http://localhost:8000/product/${id}`,{
        method: 'GET'
    });

    let data = await res.json();
    return {status: res.ok, message: data.message, data: data.data};
}


///////////////////////////////////////////////////////////////////////

document.addEventListener('DOMContentLoaded', async() =>{

    let id = localStorage.getItem('get_detail');
    let item = await Get_Product_Single(id);

    if (!item.status){
        document.getElementById('detail-body').innerHTML = 'No Product match!';
        return;
    }
    
    let data = item.data;
    //Price
    document.getElementById('product-price').innerText = `$${data.price}`;

    // Header
    let product_name = document.getElementById('product-name');
    let product_btn = document.getElementById('product-btn');

    product_name.innerText = data['name'];
    product_btn.addEventListener('click', async ()=>{
        
        const myToken = get_token();
        let add_cart = await add_to_cart(myToken, id, 1);
        alert(add_cart.message);
        window.location.href = '/pages/cart.php';
    })

    let description = JSON.parse(data.description);

    // Slider
    let slides = description.slide;
    for (let slide = 1; slide <= 4; slide++){
        // for(let pic = 1; pic <= 2; pic++){
        //     let current_pic = document.getElementById(`product-slide${slide}-img${pic}`);
        //     // current_pic.src = `../images/product-details_laptop-${pic}-image.png`;
        //     current_pic.src = slides[((slide - 1)%2)*2 + (pic - 1)];
        // }
        let current_pic = document.getElementById(`product-slide${slide}-img${1}`);
        current_pic.src = slides[slide - 1];
    }

    //Overview
    let overview = description.overview;
    for(let i = 1; i <= 3; i++){
        let img_i = document.getElementById(`overview-img-${i}`);
        let head_i = document.getElementById(`overview-head-${i}`);
        let content_i = document.getElementById(`overview-content-${i}`);

        img_i.src = overview[i - 1].img;
        head_i.innerText = overview[i - 1].header;
        content_i.innerText = overview[i - 1].description;
    }

    ///////////////////////---SPECS---///////////////////////
    let specs = JSON.parse(data['specs']);
    const optionKeys = Object.keys(specs);

    let specs_options = document.getElementById('specs-options');
    specs_options.innerHTML = '';

    for (let i = 0; i < optionKeys.length; i++){
        
        // add head
        let head = document.createElement('h5');
        head.classList.add('fw-bolder');
        head.id = `specs-option-${i}-head`;
        head.innerText = optionKeys[i];

        //add list
        let list = document.createElement('ul');
        list.innerHTML = '';
        list.id = `specs-option-${i}-list`;

        let this_specs = specs[`${optionKeys[i]}`];
        for(let idx=0; idx < this_specs.length; idx++){
            let li = document.createElement('li');
            li.textContent = this_specs[idx];
            list.appendChild(li);
        }

        // add to options
        specs_options.appendChild(head);
        specs_options.appendChild(list);
    }

    ///////////////////////---BOX---///////////////////////
    let in_the_box = description.in_the_box;

    let box_img = document.getElementById('box-img');
    let box_list = document.getElementById('box-list');

    box_img.src = in_the_box.img;

    box_list.innerHTML = '';
    if(Array.isArray(in_the_box.description)){
        for(let i = 0; i < in_the_box.description.length; i++){
            let box_li = document.createElement('li');
            box_li.innerText = in_the_box.description[i];
            box_list.appendChild(box_li);
        }
    } else{
        let box_li = document.createElement('li');
        box_li.innerText = in_the_box.description;
        box_list.appendChild(box_li);
    }

    let support_list = document.getElementById('support-list');
    support_list.innerHTML = `
        <li>Quick start guide </li>
        <li>Recommend Linux distros</li>
        <li>Factory images</li>
        <li>Safety & Compliance</li>
        <li>User manual</li>
    `
});

