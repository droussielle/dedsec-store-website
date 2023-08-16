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
    
    <title>My account</title>
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

    <div class="container bg-light p-5">
        <!-- My account and edit button -->
        <div class="row align-content-center">
            <div class="col-12">
                <h1 class="fw-bolder" style="float:left;">My account</h1>
                <!-- <button class="btn btn-primary" onclick="" style="float:right;">Edit</button> -->
            </div>
        </div>

        <!-- ACCOUNT INFORMATION FORM -->
        <div class="row align-content-center pt-5 border-bottom border-dark ">
            <div class="col-md-3 col-12">
                <h4 class="fw-bolder">Account information</h4>
            </div>
            
            <div class="col-md-9 col-12">
                <div class="d-flex align-items-start border-0 mb-3">

                    <form class="sign-up-form col-11 d-flex flex-column flex-grow-1 align-items-start gap-3 mb-4 ps-4" id="customer-infor" action="">
                        <!-- Email -->
                        <!-- <div class="w-100">
                            <label class="d-block" for="customer-infor-email">Email</label>
                            <input class="form-control p-1" type="email" name="email" id="customer-infor-email" placeholder="example@gmail.com" required>
                            <hr class="m-0">
                        </div> -->

                        <!-- Name -->
                        <div class="w-100">
                            <label class="d-block" for="customer-infor-name">Name</label>
                            <input class="form-control p-1" type="text" name="name" id="customer-infor-name" placeholder="Your Name" required>
                            <hr class="m-0">
                        </div>

                        <!-- Country -->
                        <!-- <div class="w-100">
                            <label class="d-block" for="customer-infor-country">Country</label>
                            <select class="form-select p-1" name="country" id="customer-infor-country" required>
                                <option disabled selected>Choose your Country</option>
                                <option value="1">Viet Nam</option>
                                <option value="2">Indonesia</option>
                                <option value="3">America</option>
                            </select>
                            <hr class="m-0">
                        </div> -->

                        <!-- State/Province -->
                        <!-- <div class="w-100">
                            <label class="d-block" for="customer-infor-state-province">State/Province</label>
                            <input class="form-control p-1" type="text" name="state-province" id="customer-infor-state-province" placeholder="Your state / province" required>
                            <hr class="m-0">
                        </div> -->

                        <!-- City -->
                        <!-- <div class="w-100">
                            <label class="d-block" for="customer-infor-city">City</label>
                            <input class="form-control p-1" type="text" name="city" id="customer-infor-city" placeholder="Your city" required>
                            <hr class="m-0">
                        </div> -->

                        <!-- Zip code -->
                        <!-- <div class="w-100">
                            <label class="d-block" for="customer-infor-zip">Zip code</label>
                            <input class="form-control p-1" type="text" name="zip" id="customer-infor-zip" placeholder="Your zip code" required>
                            <hr class="m-0">
                        </div> -->

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
        </div>        


    
    
    </div>
        <!-- PAYMENT METHOD FORM -->
        <!-- <div class="row align-content-center pt-5 border-bottom border-dark ">
            <div class="col-md-3 col-12">
                <h4 class="fw-bolder">Payment method</h4>
            </div>

            <div class="col-md-9 col-12">
                <div class="d-flex align-items-start border-0 mb-3">
                    <form class="sign-up-form col-11 d-flex flex-column flex-grow-1 align-items-start gap-3 mb-4 ps-4" id="customer-infor" action="">
                        <div>
                            <h6>Credit card / Debit card</h6>
                            <img src="../images/checkout_credit-cards.png" alt="credit-cards" class="pt-0 mt-0">

                        </div>

                        <div class="w-100">
                            <label class="d-block" for="name-on-card">Name on card</label>
                            <input class="form-control p-1" type="text" name="name" id="name-on-card" placeholder="Name on card" required>
                            <hr class="m-0">
                        </div>

                        <div class="w-100">
                            <label class="d-block" for="card-number">Card number</label>
                            <input class="form-control p-1" type="text" name="name" id="card-number" placeholder="Card number" required>
                            <hr class="m-0">
                        </div>

                        <div class="w-100">
                            <label class="d-block" for="expiration-date">Expiration date</label>
                            <input class="form-control p-1" type="text" name="name" id="expiration-date" placeholder="Expiration date" required>
                            <hr class="m-0">
                        </div>

                        <div class="w-100">
                            <label class="d-block" for="cvv">CVV</label>
                            <input class="form-control p-1" type="text" name="name" id="cvv" placeholder="CVV" required>
                            <hr class="m-0">
                        </div>

                    </form>
                </div>
            </div>
        </div> -->

        <!-- CHANGE PASSWORD FORM -->
        <div class="row align-content-center pt-5 ">
            <div class="col-md-3 col-12">
                <h4 class="fw-bolder">Password</h4>
            </div>
            <div class="col-md-9 col-12">
                <button class="btn btn-secondary align-self-start ms-3" onclick="" id="change-password-button" type="button">Change password</button>
                <br>
                <br>
                <div class="d-flex align-items-start border-0 mb-3">
                    <form class="sign-up-form col-11 d-flex flex-column flex-grow-1 align-items-start gap-3 mb-4 ps-4" id="customer-infor-change_pass" action="">
                        <!-- Old password-->
                        <div class="w-100">
                            <label class="d-block" for="old-password">Old password</label>
                            <input class="form-control p-1" type="password" name="password" id="old-password" placeholder="Old password">
                            <hr class="m-0">
                        </div>

                        <!-- New password-->
                        <div class="w-100">
                            <label class="d-block" for="new-password">New password</label>
                            <input class="form-control p-1" type="password" name="password" id="new-password" placeholder="New password">
                            <hr class="m-0">
                        </div>


                    </form>
                </div>

            </div>

        </div>

        <!-- Save and Cancel button -->
        <div class="row">
            <div class="col-md-1 col-3">
                <button class="btn btn-primary" onclick="" id="save-button" type="button">Save</button>
            </div>
            <div class="col-md-1 col-3">
                <button class="btn btn-secondary" onclick="" id="cancel-button" type="button">Cancel</button>

            </div>
        </div>

    </div>

    <!-- Footer -->
    <div id="footer">
        <?php include './components/footer.php';?>
    </div>

    <!-- Bootstrap 5 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
    <!-- Script for fixed navbar -->
    <script src="../scripts/fixed_navbar.js"></script>
    <!-- Handle menu bar -->
    <script src="../scripts/handle_menu.js"></script>
    <!-- Handle sign in-up -->
    <script src="../scripts/user_data/handle_sign.js"></script>
    <!-- Handle account info -->
    <script src="../scripts/user_data/account_information.js"></script>
    <!-- Handle change password -->
    <script src="../scripts/user_data/change_password.js"></script>

</body>
</html>