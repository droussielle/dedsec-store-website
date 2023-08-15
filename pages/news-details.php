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
    <title>News details</title>

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

    <!-- BODY -->
    <div class="container bg-light p-5" id="news-container">

        <!-- IMAGE -->
        <div class="row bg-light align-content-center">
            <img id="news-img" src="" alt="news image" class="img-fluid align-self-center">
        </div>

        <!-- Content -->
        <div class="row bg-light align-content-center pt-3">
            <!-- News header -->
            <h4 id="news-header" class="fw-bolder"></h4>
            <br>
            
            <div class="d-flex justify-content-between">
                <!-- Date posted -->
                <p id="posted-date" class="fs-6 fw-bold">Posted 2022/10/20</p>
                <!-- Date posted -->
                <p id="updated-date" class="fs-6 fw-bold">Updated 2022/10/20</p>
            </div>
            <br>

            <!-- Paragraphs -->
            <div id="news-content">
                <!-- <p id="paragraph-1">
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus sodales dolor quis diam volutpat, et fermentum mauris maximus. Phasellus a cursus justo, vel vulputate diam. Cras posuere, elit id commodo consequat, eros ligula mattis justo, vitae maximus libero quam eu massa. Fusce vel vehicula nisi, eu convallis nibh. Mauris rutrum in dui a aliquet. Vestibulum eros lacus, pretium sit amet nisl ac, laoreet tempor diam. Quisque tellus tortor, consequat vel est in, eleifend eleifend tortor. Praesent lorem neque, auctor eget condimentum sit amet, posuere eget neque.
                </p>
                <p id="paragraph-2">
                    Aenean sodales sodales lacus scelerisque hendrerit. In volutpat, dui sed interdum ultricies, sapien eros tincidunt sapien, nec accumsan lectus nunc eget nisi. Ut arcu metus, molestie et sodales a, tempor accumsan eros. Etiam quis ex tempor, volutpat sapien at, gravida sem. Nam posuere mollis laoreet. Duis non gravida risus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut consectetur mauris augue, in viverra augue laoreet at.
                </p>
                <p id="paragraph-3">
                    Vestibulum viverra faucibus nisi. Donec sed rutrum ipsum. Duis a mollis purus, eu pretium magna. Proin blandit eleifend lacus. Quisque tellus dolor, convallis at nisl in, varius dapibus nibh. Vestibulum eu mauris luctus, ullamcorper justo aliquam, porttitor augue. Vivamus sem nulla, condimentum eget urna sed, lacinia finibus lectus. Duis ac commodo risus, nec scelerisque velit. Maecenas sollicitudin dui ac pulvinar posuere. Nulla finibus malesuada ex. Nunc pharetra posuere tellus, id consectetur turpis bibendum sit amet. Morbi ornare felis nec leo vestibulum volutpat. Fusce vel ante varius, finibus ipsum non, lobortis enim. Aenean nec consequat velit, nec gravida metus. Duis in lorem sit amet nunc rhoncus consectetur a at leo.
                </p> -->
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
    <!-- Handle news-details -->
    <script src="/scripts/news-details.js"></script>

</body>
</html>