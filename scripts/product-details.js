/*-----------------------------ADMIN PRODUCT DETAIL MANAGEMENT-----------------------------*/

if(localStorage.getItem('user')){
    const myToken = JSON.parse(localStorage.getItem('user')).token;
    const myID = JSON.parse(localStorage.getItem('user')).data.id;

    fetch(`http://localhost:8000/user/${myID}`,{method:'GET',
    headers:{
        "Authorization": `Bearer ${myToken}`,
        "Content-Type":"application/json"
    },
    })
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);
        if(data.data.role === "ADMIN" ){
            const id = localStorage.getItem('get_detail');
            fetch(`http://localhost:8000/product/${id}`,{method: 'GET'})
            .then ((response)=>response.json())
            .then((data)=>{
                console.log("Response from backend:",data);
                localStorage.setItem("product-temporary-data",JSON.stringify(data));
            })
            .catch((error)=>{
                console.error("Error:",error);
                alert(error);
            });

            generateAdminButton();
        }  
    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });
}

function generateAdminButton(){
    var editButtons = document.getElementById("admin-button-row");
    var editProductButton = document.createElement("button");
    var deleteProductButton = document.createElement("button");
    var addToCategoryButton = document.createElement("button");
    var deleteFromCategoryButton = document.createElement("button");

    //Create edit product button
    editProductButton.className="btn btn-primary col-2 m-3";
    editProductButton.id="edit-product-button";
    editProductButton.innerHTML="Edit product";
    editProductButton.type="button";
    editProductButton.setAttribute('onclick','editProduct()');

    //Create delete product button
    deleteProductButton.className="btn btn-danger col-2 m-3";
    deleteProductButton.id="delete-product-button";
    deleteProductButton.innerHTML="Delete product";
    deleteProductButton.type="button";
    deleteProductButton.setAttribute('onclick','deleteProduct()');

    //Create add to category button
    addToCategoryButton.className="btn btn-primary col-2 m-3";
    addToCategoryButton.id="add-to-category-button";
    addToCategoryButton.innerHTML="Add to category";
    addToCategoryButton.type="button";
    addToCategoryButton.setAttribute('onclick','addToCategory()');

    //Create delete from category button
    deleteFromCategoryButton.className="btn btn-danger col-2 m-3";
    deleteFromCategoryButton.id="delete-from-category-button";
    deleteFromCategoryButton.innerHTML="Delete from category";
    deleteFromCategoryButton.type="button";
    deleteFromCategoryButton.setAttribute('onclick','deleteFromCategory()');

    //Append to page
    editButtons.appendChild(editProductButton);
    editButtons.appendChild(deleteProductButton);
    editButtons.appendChild(addToCategoryButton);
    editButtons.appendChild(deleteFromCategoryButton);

}

//ADMIN HIT EDIT PRODUCT BUTTON
function editProduct(){
    const myToken = JSON.parse(localStorage.getItem('user')).token;
    const id = localStorage.getItem('get_detail');
    var newName = prompt("Name (Cannot be empty)",JSON.parse(localStorage.getItem("product-temporary-data")).data.name);
    var newShortDescription = prompt("Short Description (Cannot be empty)",JSON.parse(localStorage.getItem("product-temporary-data")).data.short_description);
    var newDescription = prompt("Description (Cannot be empty)",JSON.parse(localStorage.getItem("product-temporary-data")).data.description);
    var newPrice = prompt("Price (Cannot be empty, float number value)",JSON.parse(localStorage.getItem("product-temporary-data")).data.price);
    var newQuantity = prompt("Quantity (Cannot be empty, integer value)",JSON.parse(localStorage.getItem("product-temporary-data")).data.quantity);
    var newImageURL = prompt("Image URL",JSON.parse(localStorage.getItem("product-temporary-data")).data.image_url);
    var newSpecs = prompt("Specs", JSON.parse(localStorage.getItem("product-temporary-data")).data.specs);

    
    // var changes=`
    //     {
    //         "name": "${newName}",
    //         "short_description": "${newShortDescription}",
    //         "description": ${JSON.stringify(newDescription.replace("'","\\'"))},
    //         "price": "${newPrice}",
    //         "quantity": "${newQuantity}",
    //         "image_url": "${newImageURL}",
    //         "specs": ${JSON.stringify(newSpecs.replace("'","\\'"))}
    //     }
    // `

    var changes=`
        {
            "name": "${newName}",
            "short_description": ${JSON.stringify(newShortDescription.replace("'","\\'"))},
            "description": ${JSON.stringify(newDescription.replace("'","\\'"))},
            "price": "${newPrice}",
            "quantity": ${newQuantity},
            "image_url": "${newImageURL}",
            "specs": ${JSON.stringify(newSpecs.replace("'","\\'"))}
        }
    `
    // alert(changes);

    fetch(`http://localhost:8000/product/${id}`,{

        method:"PATCH",
        headers:{
            "Authorization": `Bearer ${myToken}`,
            "Content-Type":"application/json"
        },
        body: changes,
})
        .then((response) => response.json())
        .then((data) => {
            console.log("Response from backend:", data);
            alert(data.message);
            window.location.reload();

        })
        .catch((error) => {
            console.error("Error:", error);
            alert(error);
        });

}   

//ADMIN HIT DELETE PRODUCT BUTTON
function deleteProduct(){
    const myToken = JSON.parse(localStorage.getItem('user')).token;
    const id = localStorage.getItem('get_detail');
    var confirmation = prompt("This action cannot be undone, type YES to confirm:",);
    if (confirmation !== "YES"){
        return;
    }
    fetch(`http://localhost:8000/product/${id}`,{method:'DELETE',
    headers:{
        "Authorization": `Bearer ${myToken}`,
        "Content-Type":"application/json"
    },
})
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);
        alert(data.message);
        window.location.href="/pages/admin/product.php";

    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });
    

}

//ADMIN HIT ADD TO CATEGORY BUTTON
function addToCategory(){
    const myToken = JSON.parse(localStorage.getItem('user')).token;
    const id = localStorage.getItem('get_detail');
    var category_id=prompt("Category id to be added to: ",);

    fetch(`http://localhost:8000/product/${id}/category`,{method:'POST',
        headers:{
            "Authorization": `Bearer ${myToken}`,
            "Content-Type":"application/json"
        },
        body: `{
            "category_id":"${category_id}"
        }`,
})
        .then((response) => response.json())
        .then((data) => {
            console.log("Response from backend:", data);
            alert(data.message);
            window.location.reload();

        })
        .catch((error) => {
            console.error("Error:", error);
            alert(error);
        });

}

//ADMIN HIT DELETE FROM CATEGORY BUTTON
function deleteFromCategory(){
    const myToken = JSON.parse(localStorage.getItem('user')).token;
    const id = localStorage.getItem('get_detail');
    var deleteCategory = prompt("Category of product to be deleted from:",);
    var confirmation = prompt("This action cannot be undone, type YES to confirm:",);
    if (confirmation !== "YES"){
        return;
    }
    fetch(`http://localhost:8000/product/${id}/category`,{method:'DELETE',
    headers:{
        "Authorization": `Bearer ${myToken}`,
        "Content-Type":"application/json"
    },
    body: `
        {
            "category_id":"${deleteCategory}"
        }
    `
})
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);
        alert(data.message);
        window.location.reload();

    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });
    
}


/*--------------------------END OF ADMIN PRODUCT DETAIL MANAGEMENT--------------------------*/


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

