//Product name
var _productName = document.getElementById("add-product-name");

//price
var _productPrice = document.getElementById("add-product-price");

// Stock
var _productStock = document.getElementById("add-product-stock");

// Short Description
var _shortDescription = document.getElementById("add-product-short-description");

// Detailed Description
var _detailedDescription = document.getElementById("add-product-detailed-description");

// Specifications
var _specifications = document.getElementById("add-product-specifications");

// Image link
var _imageLink = document.getElementById("add-product-image");


//User hit save button
var save=document.querySelector('#save-button').addEventListener('click',(event)=>{
    if (!verify()){
        return;
    }

    let added=` 
        {
            "name": "${_productName.value}",
            "short_description": "${_shortDescription.value}",
            "description": ${JSON.stringify(_detailedDescription.value.replace("'","\\'"))},
            "price": "${_productPrice.value}",
            "quantity": "${_productStock.value}",
            "image_url": "${_imageLink.value}",
            "specs": ${JSON.stringify(_specifications.value.replace("'","\\'"))}
        }
    `

    const myToken = JSON.parse(localStorage.getItem('user')).token;
    fetch("http://localhost:8000/product",{method:'POST',
        headers:{
            "Authorization": `Bearer ${myToken}`,
            "Content-Type":"application/json",
        },
        body: added,
})
        .then((response) => response.json())
        .then((data) => {
            console.log("Response from backend:", data);
            alert(data.message);
            window.location.href='/pages/admin/product.php';

        })
        .catch((error) => {
            console.error("Error:", error);
            alert(error);
        });


});

var cancel=document.querySelector('#cancel-button').addEventListener('click',(event)=>{
    window.location.href='/pages/admin/product.php';
});



//verify values
function verify(){
    //required data
    var price = _productPrice.value;
    if (_productName.value.length + _shortDescription.value.length + _detailedDescription.value.length + _productPrice.value.length + _productStock.value ==0){
        alert("Name, Short/Detailed Descriptions, Price, Stock fields cannot be empty");
        return false;        
    }   else if (isNaN.price){
        alert ("Price must be float number or integer");
        return false;
    }   
    return true;
}