<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Google Font API -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inconsolata:wght@400;500;700;900&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <!-- My css -->
    <link rel="stylesheet" href="../css/style.css">
    <title>Checkout</title>

</head>
<body class="bg-light">


    <!-- header -->
    <div id="header">
        <?php include './components/header.php';?>
    </div>

    <!-- Navigation bar -->
    <div id="navbar">
        <?php include './components/navbar.php';?>
    </div>

    <!-- BODY OF CHECKOUT -->
    <div class="checkout-container p-5">

        <!-- Header -->
        <h1 class="fw-bolder fb">Checkout</h1>

        <div class="row row-cols-lg-2">
            <!-- Information -->
            <div class="customer-information-payment">

                <!-- Customer information -->
                <div class="d-flex align-items-start border-bottom border-dark mb-3">
                    <!-- Header -->
                    <h2 class="fw-bolder fb">1</h2>

                    <form class="sign-up-form col-11 d-flex flex-column flex-grow-1 align-items-start gap-3 mb-4 ps-4" id="customer-infor">

                        <!-- Header remain -->
                        <h2 class="fw-bolder fb">Customer information</h2>
                        <!-- Logged or not -->
                        <div class="mb-2">Already have an account? <a class="fb" href="./sign.php">Sign in instead</a></div>

                        <!-- Email -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-email">Email</label>
                            <input class="form-control p-1" type="email" name="email" id="customer-infor-email" placeholder="example@gmail.com" required>
                            <hr class="m-0">
                        </div>

                        <!-- Name -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-name">Name</label>
                            <input class="form-control p-1" type="text" name="name" id="customer-infor-name" placeholder="Your Name" required>
                            <hr class="m-0">
                        </div>

                        <!-- Country -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-country">Country</label>
                            <select class="form-select p-1" name="country" id="customer-infor-country" required>
                                <option disabled selected>Choose your Country</option>
                                <option value="1">Viet Nam</option>
                                <option value="2">Indonesia</option>
                                <option value="3">America</option>
                            </select>
                            <hr class="m-0">
                        </div>

                        <!-- State/Province -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-state-province">State/Province</label>
                            <input class="form-control p-1" type="text" name="state-province" id="customer-infor-state-province" placeholder="Your state / province" required>
                            <hr class="m-0">
                        </div>

                        <!-- City -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-city">City</label>
                            <input class="form-control p-1" type="text" name="city" id="customer-infor-city" placeholder="Your city" required>
                            <hr class="m-0">
                        </div>

                        <!-- Zip code -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-zip">Zip code</label>
                            <input class="form-control p-1" type="text" name="zip" id="customer-infor-zip" placeholder="Your zip code" required>
                            <hr class="m-0">
                        </div>

                        <!-- Address -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-address">Address</label>
                            <input class="form-control p-1" type="text" name="address" id="customer-infor-address" placeholder="Your address" required>
                            <hr class="m-0">
                        </div>

                        <!-- Phone number -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-phone">Phone number</label>
                            <input class="form-control p-1" type="text" name="phone" id="customer-infor-phone" placeholder="Your phone number" required>
                            <hr class="m-0">
                        </div>
                    </form>

                </div>
                
                <!-- Payment method -->
                <div class="d-flex align-items-start border-bottom border-dark mb-3 gap-4">
                    <!-- Header -->
                    <h2 class="fw-bolder fb">2</h2>

                    <div class="w-100">

                        <!-- Header remain -->
                        <h2 class="fw-bolder fb">Payment method</h2>

                        <!-- Check list -->
                        <ul class="list-group list-group-flush" id="payment-method">

                            <!-- Credit card -->
                            <li class="form-check bg-light">

                                <input class="form-check-input rounded-0 shadow-none" type="radio" name="flexCheckIndeterminate" id="payment-method-credit-card" checked>
                                <div>
                                    <label class="form-check-label mb-2" for="payment-method-credit-card">Credit card / Debit card</label>
                                    <img class="d-block mb-4" src="../images/checkout_credit-cards.png" alt="credit-cards-thumb">
                                    <!-- Form -->
                                    <form class="sign-up-form d-flex flex-column align-items-start gap-3 mb-4" id="payment-form" action="">

                                        <!-- Name on card -->
                                        <div class="w-100">
                                            <label class="d-block" for="payment-form-name">Name on card</label>
                                            <input class="form-control p-1" type="text" id="payment-form-name" placeholder="Your Name on the Credit/Debit card" required>
                                            <hr class="m-0">
                                        </div>

                                        <!-- Card number -->
                                        <div class="w-100">
                                            <label class="d-block" for="payment-form-number">Card number</label>
                                            <input class="form-control p-1" type="number" id="payment-form-number" placeholder="Your Card number" required>
                                            <hr class="m-0">
                                        </div>

                                        <!-- Expiration date -->
                                        <div class="w-100">
                                            <label class="d-block" for="payment-form-exp">Expiration date</label>
                                            <input class="form-control p-1" type="text" id="payment-form-exp" placeholder="Expiration date mm-yy" required>
                                            <hr class="m-0">
                                        </div>

                                        <!-- CVV -->
                                        <div class="w-100">
                                            <label class="d-block" for="payment-form-cvv">CVV</label>
                                            <input class="form-control p-1" type="number" id="payment-form-cvv" placeholder="CVV (3 numbers)" required>
                                            <hr class="m-0">
                                        </div>
                    
                                        
                                    </form>
                                </div>
                                
                            </li>

                            <!-- PayPal -->
                            <li class="form-check bg-light">
                                <input class="form-check-input rounded-0 shadow-none" type="radio" name="flexCheckIndeterminate" id="payment-method-paypal">
                                <div>
                                    <label class="form-check-label mb-2" for="payment-method-paypal">PayPal</label>
                                    <img class="d-block mb-3" src="../images/checkout_PayPal-logo.png" alt="PayPal-logo">
                                </div>
                                
                            </li>

                            <!-- Google Pay -->
                            <li class="form-check bg-light">
                                <input class="form-check-input rounded-0 shadow-none" type="radio" name="flexCheckIndeterminate" id="payment-method-googlepay">
                                <div>
                                    <label class="form-check-label mb-2" for="payment-method-googlepay">Google Pay</label>
                                    <img class="d-block mb-3" src="../images/checkout_GooglePay-logo.png" alt="GooglePay-logo">
                                </div>
                            </li>
                        </ul>

                    </div>

                </div>
            </div>  
            

            <!-- Order summary -->
            <div class="big-order-container d-flex justify-content-md-end justify-content-center justify-content-lg-center">

                <div>
                    <div class="order-container py-5 px-4" style="background-color: #F2F2F2; border-radius: 10px;">
                        
                        <!-- Header -->
                        <h4 class="fw-bolder">Order summary</h4>

                        <!-- Product's ordered -container -->
                        <div class="product-order-container border-bottom border-dark" id="Products-Container">

                            <!-- template -->
                            <!-- <div class="row mb-4" id="${id}">
                                img
                                <div class="col-md-3 col-4">
                                    <img id="product-${id}-img" src="/images/products/dedsec-laptop-13.png" alt="" class="rounded img-fluid">
                                </div>

                                Content
                                <div class="col-md-9 col-8 d-flex justify-content-between">

                                    <div class="d-flex flex-column justify-content-between">
                                        Name
                                        <div id="product-${id}-name" class="fw-bolder">
                                            DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series)
                                        </div>
                                        qty
                                        <div id="product-${id}-qty">Qty: 1</div>
                                    </div>

                                    price
                                    <div id="product-${id}-price" class="fw-bolder">$2499.00</div>

                                </div>
                            </div> -->
                            <!-- end of template -->

                        </div>

                        <!-- checkout result -->
                        <div class="border-bottom border-dark" id="checkout-result">

                            <!-- Delivery -->
                            <div class="d-flex justify-content-between my-3">
                                <div>Delivery</div>
                                <div id="checkout-result-delivery"></div>
                            </div>

                            <!-- Subtotal -->
                            <div class="d-flex justify-content-between mb-3">
                                <div>Subtotal</div>
                                <div id="checkout-result-subtotal"></div>
                            </div>

                            <!-- Estimated tax -->
                            <div class="d-flex justify-content-between mb-3">
                                <div>Estimated tax</div>
                                <div id="checkout-result-estimated"></div>
                            </div>

                            <!-- Shipping -->
                            <div class="d-flex justify-content-between mb-3">
                                <div>Shipping</div>
                                <div id="checkout-result-shipping"></div>
                            </div>
                        </div>

                        <!-- Total result -->
                        <div class="total-result">

                            <!-- Total -->
                            <div class="d-flex justify-content-between my-3">
                                <div class="fw-bolder">Total</div>
                                <div class="fw-bolder" id="total-result-total"></div>
                            </div>

                            <!-- Warning -->
                            <div style="font-size: 12px;">
                                Please double-check your order details. 
                                Orders cannot be modified once submitted.
                            </div>
                        </div>

                    </div>

                    <!-- Button for payment -->
                    <button class="w-100 btn btn-primary mt-4" id="place-order-btn">Place order ⟶</button>
                </div>

            </div>

        </div>
    </div>
    <!-- END OF BODY -->

    <!-- Footer -->
    <div id="footer">
        <?php include './components/footer.php';?>
    </div>

    <!-- Bootstrap 5 -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
    <!-- Script for fixed navbar -->
    <script src="../scripts/fixed_navbar.js"></script>
    <!-- Handle menu bar -->
    <script src="../scripts/handle_menu.js"></script>
    <!-- Handle sign in-up -->
    <script src="../scripts/user_data/handle_sign.js"></script>
    <!-- Handle checkout -->
    <script src="/scripts/handle_checkout.js"></script>
</body>
</html>