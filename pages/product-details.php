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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <!-- My css -->
    <link rel="stylesheet" href="../css/style.css">
    <title>Products</title>

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
    <div class="bg-light row p-md-5 m-0" id="detail-body">
        <div class="container ps-md-5 pe-md-5 bg-light">
            
            <div class="row" id="admin-button-row">
                <a class="fb fw-bold" href="./product.php"><img src="../images/product-details_back_icon.png" alt="back_icon"> Back to products</a>
            </div>
            <br>

            <!-- Slider -->
            <div id="mySlider" class="carousel slide" data-bs-ride="carousel">
                <!-- Product name and Add to card button--> 
                <div class="row align-content-center">
                    <div class="col">
                        <h4 id="product-name" class="fw-bolder">Product name</h4>
                    </div>
                    <div class="col">
                        <button id='product-btn' class="btn btn-primary" type="button" onclick="" style="float:right;">Add to cart</button>
                    </div>
                </div>

                <!-- Price -->
                <div class="row  align-content-center">
                    <h4 id="product-price">$$$</h4>
                </div>
                <!-- Slide inner -->
                <div class="carousel-inner">
                    <!-- Slide 1 -->
                    <div class="carousel-item active">
                        <div class="row justify-content-center m-0">
                            <img id='product-slide1-img1' src="" alt="laptop-1-image" class="col-lg-5 col-8 img-fluid p-0 rounded-2">
                            <!-- <img id='product-slide1-img2' src="../images/product-details_laptop-2-image.png" alt="laptop-2-image" class="col-4 img-fluid" style="width: max-content; height: max-content;"> -->
                        </div>
                    </div>
                    
        
                    <!-- Slide 2 -->
                    <div class="carousel-item">
                        <!-- Image -->
                        <div class="row justify-content-center m-0">
                            <img id='product-slide2-img1' src="" alt="laptop-1-image" class="col-lg-5 col-8 img-fluid p-0 rounded-2">
                            <!-- <img id='product-slide2-img2' src="../images/product-details_laptop-2-image.png" alt="laptop-2-image" class="col-4 img-fluid" style="width: max-content; height: max-content;"> -->
                        </div>
                    </div>
        
                    <!-- Slide 3 -->
                    <div class="carousel-item">
                        <!-- Image -->
                        <div class="row justify-content-center m-0">
                            <img id='product-slide3-img1' src="" alt="laptop-1-image" class="col-lg-5 col-8 img-fluid p-0 rounded-2">
                            <!-- <img id='product-slide3-img2' src="../images/product-details_laptop-2-image.png" alt="laptop-2-image" class="col-4 img-fluid" style="width: max-content; height: max-content;"> -->
                        </div>
                    </div>

                    <!-- Slide 4 -->
                    <div class="carousel-item">
                        <!-- Image -->
                        <div class="row justify-content-center m-0">
                            <img id='product-slide4-img1' src="" alt="laptop-1-image" class="col-lg-5 col-8 img-fluid p-0 rounded-2">
                            <!-- <img id='product-slide4-img2' src="../images/product-details_laptop-2-image.png" alt="laptop-2-image" class="col-4 img-fluid" style="width: max-content; height: max-content;"> -->
                        </div>

                    </div>
                    <!-- End of slide -->
                </div>
            
            </div>
        
            <!-- Page navigation -->
            <div class="d-flex pg-nav align-content-center justify-content-center bg-light">
                <div class="pg-nav-main">
                    <!-- Arrow left -->
                    <button class="btn btn-light m-0" data-bs-target="#mySlider" data-bs-slide="prev">
                        <!-- <div class="pg-nav-arrow-l"></div> -->
                        <img src="../images/product-details_prev_icon.png" alt="previous">
                    </button>
                    
                    <!-- Box -->
                    <div class="pg-nav-box-container">
                        <div class="pg-nav-box bg-black" data-bs-target="#mySlider" data-bs-slide-to="0"></div>
                        <div class="pg-nav-box" data-bs-target="#mySlider" data-bs-slide-to="1"></div>
                        <div class="pg-nav-box" data-bs-target="#mySlider" data-bs-slide-to="2"></div>
                        <div class="pg-nav-box" data-bs-target="#mySlider" data-bs-slide-to="3"></div>
                    </div>

                    <!-- Arrow right -->
                    <button class="btn btn-light m-0" data-bs-target="#mySlider" data-bs-slide="next">
                        <!-- <div class="pg-nav-arrow-r" ></div> -->
                        <img src="../images/product-details_forw_icon.png" alt="forward">

                    </button>

                </div>
            </div>


            <!-- Menu bar -->
            <div class="row border-0 border-top border-bottom border-black justify-content-center fw-bolder pt-2 pb-2  align-content-center">
                <div class="col text-center">
                    <a href="#scrollspyHeading1" style="text-decoration: none; color: black;">Overview</a>
                </div>
                <div class="col text-center">
                    <a href="#scrollspyHeading2"style="text-decoration: none;color: black;">Specs</a>
                </div>
                <div class="col text-center">
                    <a href="#scrollspyHeading3"style="text-decoration: none;color: black;">What's in the box</a>
                </div>
                <div class="col text-center">
                    <a href="#scrollspyHeading4"style="text-decoration: none;color: black;">Support</a>
                </div>
            </div>

            <!-- Main content -->
            <div data-bs-spy="scroll" data-bs-root-margin="0px 0px -40%" data-bs-smoot="true" class="scrollspy-example bg-body-tertiary p-md-3 rounded-2 bg-light  align-content-center" tabindex="0">
                <!-- Overview -->
                <div class="container row border-0 border-bottom border-dark ">
                    
                    <div class="col-md-2 col-12"><h4 id="scrollspyHeading1" class="fw-bolder">Overview</h4></div>

                    <div class="col-md-10 col-12" id='overview-container'>

                        <!-- Truly personal computing -->
                        <div class="row">
                            <div class="col-md-8 col-12 text-end">
                                <img id="overview-img-1" src="" alt="truly-img" class="img-fluid pe-md-5">
                            </div>
                            <div class="col-md-4 col-12 text-start align-self-center">
                                <h5 class="fw-bolder" id='overview-head-1'></h5>
                                <p id='overview-content-1'></p>
                            </div>
                        </div>
                        <br>
                        <br>

                        <!-- Expansion Cards -->
                        <div class="row">
                            <div class="col-md-4 col-12 text-end align-self-center order-md-0 order-1">
                                <h5 class="fw-bolder" id="overview-head-2"></h5>
                                <p id="overview-content-2"></p>
                            </div>
                            <div class="col-md-8 col-12 text-end order-md-1 order-0">
                                <img id="overview-img-2" src="" alt="overview-image-2" class="img-fluid ps-md-5">
                            </div>
                        </div>
                        <br>
                        <br>

                        <!-- Keyboard -->
                        <div class="row justify-content-center">
                            <img id="overview-img-3" src="" alt="overview-image-3" class="img-fluid">
                            
                            <div class="text-center">
                                <h5 id="overview-head-3" class="fw-bolder pt-3"></h5>
                                <p id="overview-content-3"></p>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Specs -->
                <div class="container row pt-3 border-0 border-bottom border-dark">
                    <div class="col-md-2 col-12"><h4 id="scrollspyHeading2" class="fw-bolder">Specs</h4></div>
                    <div class="col-md-10 col-12" id="specs-options">

                        <!-- Processor options -->
                        <h5 class="fw-bolder" id="specs-option-1-head">Processor options</h5>
                        <ul id="specs-option-1-list">
                            <li>DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores) </li>
                            <li>ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)</li>
                            <li>ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)</li>
                        </ul>

                        <!-- Memory ooptions -->
                        <h5 class="fw-bolder" id="specs-option-2-head">Memory options</h5>
                        <ul id="specs-option-2-list">
                            <li>DDR5-5600 - 8GB (1 x 8GB)</li>
                            <li>DDR5-5600 - 16GB (2 x 8GB)</li>
                            <li>DDR5-5600 - 16GB (1 x 16GB)</li>
                            <li>DDR5-5600 - 32GB (1 x 32GB)</li>
                            <li>DDR5-5600 - 32GB (2 x 16GB)</li>
                            <li>DDR5-5600 - 64GB (2 x 32GB)</li>
                        </ul>

                        <!-- Storage options -->
                        <h5 class="fw-bolder" id="specs-option-3-head">Storage options</h5>
                        <ul id="specs-option-3-list">
                            <li>WW_BLACK™ SN770 NVMe™- M.2 2280 - 250GB</li>
                            <li>WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB</li>
                            <li>WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB</li>
                            <li>WW_BLACK™ SN770 NVMe™- M.2 2280 - 2TB</li>
                            <li>WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB</li>
                            <li> WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB</li>
                            <li> WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB</li>
                        </ul>

                        <!-- Graphics -->
                        <h5 class="fw-bolder" id="specs-option-4-head">Graphics</h5>
                        <ul id="specs-option-4-list">
                            <li>Radeon™ 700M Graphics</li>
                            <li>ENTEL® Iris™ XP</li>
                        </ul>

                        <!-- Display -->
                        <h5 class="fw-bolder" id="specs-option-5-head">Display</h5>
                        <ul id="specs-option-5-list">
                            <li>13.5” 3:2 2256*1504px </li>
                            <li>100% sRGB coverage, 1500:1 contrast, >400 nits brightness</li>
                            <li>Available in matte and glossy covers</li>
                        </ul>

                        <!-- Battery -->
                        <h5 class="fw-bolder" id="specs-option-6-head">Battery</h5>
                        <ul id="specs-option-6-list">
                            <li>55Wh</li>
                            <li>61Wh</li>
                        </ul>

                        <!-- Operating system -->
                        <h5 class="fw-bolder" id="specs-option-7-head">Operating system</h5>
                        <ul id="specs-option-7-list">
                            <li>Michealsoft Door 11 Home </li>
                            <li>Michealsoft Door 11 Pro</li>
                            <li>DEDSEC ctOS Workstation</li>
                            <li>None (bring your own) - Check out our recommended Linux distros</li>
                        </ul>

                    </div>

                </div>

                <!-- What's in the box -->
                <div class="container row pt-3 border-0 border-bottom border-dark">
                    <div class="col-md-2 col-12"><h4 id="scrollspyHeading3" class="fw-bolder">What's in the box</h4></div>
                    <div class="col-md-10 col-12">
                        <img id="box-img" src="" alt="whats-in-the-box" class="img-fluid">

                        <ul id="box-list">                  
                        </ul>
                    </div>

                </div>
                <!-- Support -->
                <div class="container row pt-3 ">
                    <div class="col-md-2 col-12"><h4 id="scrollspyHeading4" class="fw-bolder">Support</h4></div>
                    <div class="col-md-10 col-12 pt-3">
                        <ul id="support-list">
                            <li>Quick start guide </li>
                            <li>Recommend Linux distros</li>
                            <li>Factory images</li>
                            <li>Safety & Compliance</li>
                            <li>User manual</li>
                        </ul>
                    </div>
                </div>


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
    <!-- Adding script for slider change -->
    <script src="../scripts/for_slider.js"></script>
    <!-- Handle sign in-up -->
    <script src="../scripts/user_data/handle_sign.js"></script>
    <!-- Product details -->
    <script src="../scripts/product-details.js"></script>
</body>
</html>