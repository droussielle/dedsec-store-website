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
    <title>Latest news</title>

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

    
    <!-- Latest news -->
    <div class="px-5 py-5" style="background: #DDD;">

        <a href="./news.php">
            <div class="latest-news-content mb-5">Latest news ></div>
        </a>
        
        <!-- <div class="d-flex justify-content-between row row-cols-lg-3 row-cols-md-2 row-cols-sm-1 latest-news"> -->
        <div class="row row-cols-lg-3 row-cols-md-2 row-cols-sm-1 latest-news" id="news-container">
            <!-- Card 1 -->
            <!-- <div class="card pe-5 mb-5 border-0" style="background: #DDD;">
                <img src="./img/products-img.jfif" class="card-img-top" alt="...">
                <div class="card-body p-0">
                    <div class="card-head my-2">Phone news</div>
                    <div class="card-description">
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                        Nam id rhoncus augue, id bibendum magna. Nulla urna nibh, 
                        ornare sit amet lacinia vel, accumsan non diam.
                    </div>
                </div>
            </div> -->

            
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
    <!-- Handle sign in-up -->
    <script src="../scripts/user_data/handle_sign.js"></script>
    <!-- News loader -->
    <script src="../scripts/news_loader.js"></script>
    
</body>
</html>