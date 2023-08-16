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
    <title>Sign in / Sign up</title>

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

    

    <!-- Sign in/up -->
    <div class="form-container d-flex flex-column align-items-center">
        <div class="gap-5">
            <!-- Sign in section -->
            <form class="sign-in-form d-flex flex-column align-items-start gap-3 mb-4 p-4 shadow rounded-3" action="">
                
                <!-- Header form -->
                <div class="sign-header-font">Sign in</div>

                <!-- label and input -->
                <label class="sign-title-font d-block" for="sign-in-email">Email</label>
                <input class="sign-input-layout" type="email" id="sign-in-email" name="sign-in-email" placeholder="Email">

                <label class="sign-title-font d-block" for="sign-in-password">Password</label>
                <input class="sign-input-layout" type="password" id="sign-in-password" name="sign-in-password" placeholder="Password">
                
                <!-- button submit -->
                <div>
                    <button class="btn btn-primary sign-btn-font" type="button" id="sign-in-button">Sign in</button>
                </div>
            </form>

            <!-- Sign up section -->
            <form class="sign-up-form d-flex flex-column align-items-start gap-3 mb-4 p-4 shadow rounded-3" action="">
                
                <!-- Header form -->
                <div class="sign-header-font">Don't have an account? Sign up instead</div>

                <!-- label and input -->

                <label class="sign-title-font d-block" for="sign-up-name">Name</label>
                <input class="sign-input-layout" type="text" id="sign-up-name" name="sign-up-name" placeholder="More than 1 character">

                <label class="sign-title-font d-block" for="sign-up-phone">Phone number</label>
                <input class="sign-input-layout" type="text" id="sign-up-phone" name="sign-up-phone" placeholder="Exact 10 characters">

                <label class="sign-title-font d-block" for="sign-up-address">Address</label>
                <input class="sign-input-layout" type="text" id="sign-up-address" name="sign-up-address" placeholder="Address">

                <label class="sign-title-font d-block" for="sign-up-email">Email</label>
                <input class="sign-input-layout" type="email" id="sign-up-email" name="sign-up-email" placeholder="Email">

                <label class="sign-title-font d-block" for="sign-up-password">Password</label>
                <input class="sign-input-layout" type="password" id="sign-up-password" name="sign-up-password" placeholder="More than 5 characters">
                
                <label class="sign-title-font d-block" for="sign-up-password-confirm">Password confirmation</label>
                <input class="sign-input-layout" type="password" id="sign-up-password-confirm" name="sign-up-password-confirm" placeholder="Confirm your password">

                <!-- Terms and Policy -->
                <div class="sign-footer-font">
                    By creating an account you are agreeing to 
                    <a class="sign-footer-font" href="https://www.iubenda.com/terms-and-conditions/28927739">Terms of Service</a> and 
                    <a class="sign-footer-font" href="https://www.iubenda.com/privacy-policy/28927739">Privacy Policy</a>
                </div>
                <!-- button submit -->
                <div>
                    <button class="btn btn-primary sign-btn-font" id="sign-up-button" type="button">Sign up</button>
                </div>
            </form>

            <!-- Forgot password section -->
            <form class="sign-forgot-form d-flex flex-column align-items-start gap-3 mb-4 p-4 shadow rounded-3" action="">
                
                <!-- Header form -->
                <div class="sign-header-font">Forgot password?</div>

                <!-- label and input -->
                <label class="sign-title-font d-block" for="sign-forgot-email">Type your email to get started</label>
                <input class="sign-input-layout" type="email" id="sign-forgot-email" name="sign-forgot-email" placeholder="Email">

                <!-- button submit -->
                <div>
                    <button class="btn btn-primary sign-btn-font" type="button" id="forgot-password-button">Submit</button>
                </div>
            </form>
        </div>
    </div>



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
    <!-- Handle sign in -->
    <script src="../scripts/user_data/sign_in_controller.js"></script>
    <!-- Handle sign up -->
    <script src="../scripts/user_data/sign_up_controller.js"></script>
    <!-- Handle forgot password button -->
    <script src="../scripts/user_data/forgot_password_controller.js"></script>
    <!-- Handle sign -->
    <script src="../scripts/user_data/handle_sign.js"></script>

    
</body>
</html>