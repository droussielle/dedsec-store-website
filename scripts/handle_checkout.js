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

//////////////---FORMAT ITEM---////////////////
function generateItem(id, name, image_url, price, quantity){
    
    // Create template
    var product_template = document.createElement('div');
    product_template.className = 'row mb-4';
    product_template.id = `${id}`;

    var product_body = `    
        <div class="col-md-3 col-4">
            <img id="product-${id}-img" src="${image_url}" alt="" class="rounded img-fluid">
        </div>

        <div class="col-md-9 col-8 d-flex justify-content-between">

            <div class="d-flex flex-column justify-content-between">
                <div id="product-${id}-name" class="fw-bolder">${name}</div>
                <div id="product-${id}-qty">Qty: ${quantity}</div>
            </div>

            <div id="product-${id}-price" class="fw-bolder">$${price}</div>

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
        let quantity = current_item['quantity'];

        // Generate Product templates
        let product_template = generateItem(id, name, image_url, price, quantity)

        // Append to Products-container
        product_container.appendChild(product_template);
    }

    return products_cart.data;
}

function update_order(products_cart){

    let delivery = document.getElementById('checkout-result-delivery');
    let subtotal = document.getElementById('checkout-result-subtotal');
    let estimated_tax = document.getElementById('checkout-result-estimated');
    let shipping = document.getElementById('checkout-result-shipping');
    let total_price = document.getElementById('total-result-total');

    // Date
    let today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    delivery_date = mm + '/' + dd + '/' + yyyy;

    // Others
    let subtotal_value = (0).toFixed(2);
    let estimated_tax_value = (0).toFixed(2);
    let shipping_value = (0).toFixed(2);
    let total = products_cart.total;
    total = parseFloat(total);
    total = total.toFixed(2);

    delivery.textContent = `${delivery_date}`;
    subtotal.textContent = `$${subtotal_value}`;
    estimated_tax.textContent = `$${estimated_tax_value}`;
    shipping.textContent = `$${shipping_value}`;
    total_price.textContent = `$${total}`;
}

async function autofill_infor(){

    let email = document.getElementById('customer-infor-email');
    let name = document.getElementById('customer-infor-name');
    let address = document.getElementById('customer-infor-address');
    let phone =document.getElementById('customer-infor-phone');

    let user_data = JSON.parse(localStorage.getItem('user'));
    let myToken = user_data.token;
    let myID = user_data.data.id;
    let user_infor = await get_infor(myToken, myID);

    if(!user_infor.status) return;

    email.value = user_infor.data.email;

    user_data = user_infor.data.info;
    name.value = user_data.name;
    address.value = user_data.address;
    phone.value = user_data.phone;
}

async function get_infor(myToken, myID){

    let res = await fetch(`http://localhost:8000/user/${myID}`, {
        method: 'GET',
        headers:{
            "Authorization": `Bearer ${myToken}`,
            "Content-Type":"application/json"
        }
    });

    let data = await res.json();
    return {status: res.ok, message: data.message, data: data.data};
}



document.addEventListener('DOMContentLoaded', async ()=>{
    let products_cart = await Load_Product_List();
    update_order(products_cart);
    let autofill = await autofill_infor();
});

// Function to validate the form fields
// Function to validate the form fields
function validateForm() {
    const email = document.getElementById('customer-infor-email').value;
    const name = document.getElementById('customer-infor-name').value;
    const country = document.getElementById('customer-infor-country').value;
    const stateProvince = document.getElementById('customer-infor-state-province').value;
    const city = document.getElementById('customer-infor-city').value;
    const zip = document.getElementById('customer-infor-zip').value;
    const address = document.getElementById('customer-infor-address').value;
    const phoneNumber = document.getElementById('customer-infor-phone').value;

    // Validate email
    if (!email.match(/^\S+@\S+\.\S+$/)) {
        alert('Invalid email');
        return false;
    }

    // Validate name
    if (name.trim().length === 0) {
        alert('Name is required');
        return false;
    }

    // Validate country
    if (country === 'Choose your Country') {
        alert('Please select a country');
        return false;
    }

    // Validate state/province
    if (stateProvince.trim().length === 0) {
        alert('State/Province is required');
        return false;
    }

    // Validate city
    if (city.trim().length === 0) {
        alert('City is required');
        return false;
    }

    // Validate zip code
    if (zip.trim().length === 0) {
        alert('Zip code is required');
        return false;
    }

    // Validate address
    if (address.trim().length === 0) {
        alert('Address is required');
        return false;
    }

    // Validate phone number
    if (phoneNumber.length !== 10 || isNaN(phoneNumber)) {
        alert('Invalid phone number');
        return false;
    }

    return true; // All validations passed
  }
  

// Function to validate the payment form
function validatePaymentForm() {
    const cardName = document.getElementById('payment-form-name').value;
    const cardNumber = document.getElementById('payment-form-number').value;
    const expDateInput = document.getElementById('payment-form-exp').value;
    const cvv = document.getElementById('payment-form-cvv').value;
  
    // Validate card name
    if (cardName.trim().length === 0) {
        alert('Name on card is required');
        return false;
    }
  
    // Validate card number
    if (cardNumber.trim().length === 0) {
        alert('Card number is required');
        return false;
    }
  
    // Validate expiration date format (mm-yy)
    const expDateRegex = /^(0[1-9]|1[0-2])-(\d{2})$/;
    if (!expDateInput.match(expDateRegex)) {
        alert('Invalid expiration date format. Please use mm-yy format.');
        return false;
    }
  
    // Validate CVV (3 characters)
    if (cvv.length !== 3) {
        alert('CVV must be 3 characters long');
        return false;
    }
  
    return true; // All validations passed
}

// Automatically format the expiration date input (mm-yy)
const expDateInput = document.getElementById('payment-form-exp');
expDateInput.addEventListener('input', (event) => {
    const input = event.target;
    const value = input.value.replace(/\D/g, ''); // Remove non-numeric characters

    if (value.length >= 5) {
        input.value = `${value.slice(0, 2)}-${value.slice(2, 4)}`;
    } 
    else if (value.length > 2) {
        input.value = `${value.slice(0, 2)}-${value.slice(2)}`;
    } else {
        input.value = value;
    }
});

async function Order_Cart(myToken, myAddress){

    const res = await fetch(`http://localhost:8000/cart/checkout`,{
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${myToken}`
        },

        body:`{
            "ship_address": "${myAddress}",
            "note": "ship faster !!"
        }
        `
    });

    let data = await res.json();

    return {status: res.ok, message: data.message};
}

document.getElementById('place-order-btn').addEventListener('click', async (event)=>{

    event.preventDefault();
    const selectedMethod = document.querySelector('input[name="flexCheckIndeterminate"]:checked').id;

    if (!validateForm()) return;

    if (selectedMethod === 'payment-method-credit-card') {
        if (!validatePaymentForm()) return;
    }

    // Payment form validation passed, you can proceed to process or send the data
    const customerForm = document.getElementById('customer-infor');
    const paymentForm = document.getElementById('payment-form');

    const customerFormData = new FormData(customerForm);
    const paymentFormData = new FormData(paymentForm);

    // Process or send customerFormData and paymentFormData as needed

    const myToken = get_token();
    const myAddress = document.getElementById('customer-infor-address').value;
    let order = await Order_Cart(myToken, myAddress);
    alert(order.message);

    customerForm.reset(); // Reset the customer form
    paymentForm.reset(); // Reset the payment form

    window.location.href = '/index.php';
});
