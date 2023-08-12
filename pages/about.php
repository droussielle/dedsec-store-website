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

    <title>About us</title>
</head>
<body class="bg-light body-theme-fw">


    <!-- header -->
    <div id="header">
        <?php include './components/header.php';?>
    </div>

    <!-- Navigation bar -->
    <div id="navbar">
        <?php include './components/navbar.php';?>
    </div>

    <!-- BODY -->
    <div class="bg-black row p-5 m-0">
        <!-- ABOUT US paragraph 1--> 
        <!-- align-self-lg-start -->
        <div class="bg-black col-lg-5 order-lg-0 order-sm-1 order-1 d-flex align-items-center" id="about-us-paragraph-1">
            <div>
                <h1 style="font-weight: bolder;">About us</h1>
                <p>Established in 2006, our goal is to deliver a specialist range of microcontrollers and boards for enthusiasts. 
                    Since then, we have expanded into computers and personal devices that are open to repair and upgrade, 
                    unlike most products on the market.</p>
            </div>
        </div>
        
        <!-- ABOUT US image -->
        <div class="bg-black col-lg-7 align-self-lg-center order-lg-1 order-sm-0  order-0">
            <img src="../images/about_about-us-img.png" alt="about-us-img" class="img-fluid float-end">
        </div>

        <!-- ABOUT US paragraph 2 -->
        <div class="bg-black col-5 align-self-start align-items-center order-lg-3 order-sm-4 order-4"></div>
        <div class="bg-black col-lg-7 align-self-end justify-content-md-end order-lg-4 order-sm-3 order-3" id="about-us-paragraph-2">
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                Etiam blandit sed erat eget tempus. Phasellus ac nibh vitae nunc rutrum porttitor. 
                Fusce ultrices tellus nec tortor eleifend, in suscipit lacus iaculis. Mauris elit nibh, 
                tincidunt ac est ut, sollicitudin tincidunt leo. Donec volutpat vitae augue id vestibulum. 
                Cras id lorem fermentum, scelerisque enim quis, malesuada mi. Nam enim lorem, varius mollis 
                eros et, placerat mollis nibh. Cras varius, ante ac rutrum cursus, justo nibh sagittis massa, 
                eu mollis risus erat vel enim. Integer malesuada tincidunt volutpat.</p>
        </div>

    </div>


    <!-- HELPING HANDS -->
    <div class="bg-black row p-5 m-0">
        <div class="row">
            <h3 style="font-weight: bolder;">DEDSEC Helping Hands</h3>
        </div>
        <div class="col-lg-10 order-sm-1 order-md-0 order-lg-0 order-1 order-sm-1">
            <p>Started in November 2008, Helping Hands allows employees to donate to 10 charity partners 
                through regular payroll deductions. All donations are matched by us. 
                We recognise the responsibility to give back to the community and believe 
                workplace giving is an efficient and effective way to do so. With DEDSEC 
                matching staff contributions dollar-for-dollar we effectively double the 
                positive impact to our charities and community.</p>
        </div>
        <div class="col-lg-2 order-sm-0 order-md-1  order-lg-1 order-0 order-sm-0">
            <img src="../images/about_helping-hands.png" alt="helping-hands">
        </div>
    </div>

    <!-- CHARITIES WE SUPPORT -->

    <div class="bg-black row p-5 m-0">
        <h3 style="font-weight: bolder;">Charities we support</h3>
        <div class="row ">
            <div class="col-lg-4 col-md-6 pb-4">
                <div class="row">
                    <div class="d-flex align-items-center justify-content-center pb-3">
                        <img src="../images/about_charities_1.png" alt="">
                    </div>
                    <h3 style="font-weight: bolder;">The Fred Hollows Foundation</h3>
                    <p>The Fred Hollows Foundation is a lean and independent, non-profit, secular organisation. 
                        The Foundation has worked in over 40 countries around the world and with Indigenous 
                        communities in remote parts of Australia, and continues to be inspired by Fred’s lifelong 
                        endeavour to end avoidable blindness and improve Indigenous health.</p>
                </div>
            </div>

            <div class="col-lg-4 col-md-6 pb-4">
                <div class="row">
                    <div class="d-flex align-items-center justify-content-center pb-3">
                        <img src="../images/about_charities_2.png" alt="" class="align-content-center">
                    </div>
                    
                    <h3 style="font-weight: bolder;">The Fred Hollows Foundation</h3>
                    <p>The Fred Hollows Foundation is a lean and independent, non-profit, secular organisation. 
                        The Foundation has worked in over 40 countries around the world and with Indigenous 
                        communities in remote parts of Australia, and continues to be inspired by Fred’s 
                        lifelong endeavour to end avoidable blindness and improve Indigenous health.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 pb-4">
                <div class="row">
                    <div class="d-flex align-items-center justify-content-center pb-3">
                        <img src="../images/about_charities_3.png" alt="" class="align-content-center">
                    </div>
                    
                    <h3 style="font-weight: bolder;">The Fred Hollows Foundation</h3>
                    <p>The Fred Hollows Foundation is a lean and independent, non-profit, secular organisation. 
                        The Foundation has worked in over 40 countries around the world and with Indigenous 
                        communities in remote parts of Australia, and continues to be inspired by Fred’s 
                        lifelong endeavour to end avoidable blindness and improve Indigenous health.</p>
                </div>
            </div>
            <div class="col-lg-4 col-md-6 pb-4">
                <div class="row">
                    <div class="d-flex align-items-center justify-content-center pb-3">
                        <img src="../images/about_charities_4.png" alt="" class="align-content-center">
                    </div>
                    
                    <h3 style="font-weight: bolder;">The Fred Hollows Foundation</h3>
                    <p>The Fred Hollows Foundation is a lean and independent, non-profit, secular organisation. 
                        The Foundation has worked in over 40 countries around the world and with Indigenous 
                        communities in remote parts of Australia, and continues to be inspired by Fred’s 
                        lifelong endeavour to end avoidable blindness and improve Indigenous health.</p>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
    <!-- Script for fixed navbar -->
    <script src="../scripts/fixed_navbar.js"></script>
    <!-- Handle menu bar -->
    <script src="../scripts/handle_menu.js"></script>
    <!-- Handle sign in-up -->
    <script src="../scripts/user_data/handle_sign.js"></script>

</body>
</html>