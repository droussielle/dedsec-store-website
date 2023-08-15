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
    <link rel="stylesheet" href="../../css/style.css">
    <title>Products</title>

</head>
<body class="bg-light">


    <!-- header -->
    <div id="header">
        <?php include '../components/header-admin.php';?>
    </div>

    <!-- Navigation bar -->
    <div id="navbar">
        <?php include '../components/navbar-admin.php';?>
    </div>

    <!-- BODY -->
    <div class="container bg-light p-5">
        <!-- My account and edit button -->
        <div class="row align-content-center">
            <div class="col-12">
                <h1 class="fw-bolder" style="float:left;">Add product</h1>
                <!-- <button class="btn btn-primary" onclick="" style="float:right;">Edit</button> -->
            </div>
        </div>

        <!-- ACCOUNT INFORMATION FORM -->
        <div class="row align-content-center pt-5  ">
            <div class="col-md-3 col-12">
                <!-- <h4 class="fw-bolder">Add product</h4> -->
            </div>
            
            <div class="col-md-9 col-12">
                <div class="d-flex align-items-start border-0 mb-3">

                    <form class="sign-up-form col-11 d-flex flex-column flex-grow-1 align-items-start gap-3 mb-4 ps-4" id="customer-infor" action="">


                        <!-- Product name -->
                        <div class="w-100">
                            <label class="d-block" for="add-product-name">Product name</label>
                            <input class="form-control p-1" type="text" name="product-name" id="add-product-name" placeholder="Title" required>
                            <hr class="m-0">
                        </div>

                        <!-- price -->
                        <div class="w-100">
                            <label class="d-block" for="add-product-price">Price</label>
                            <input class="form-control p-1" type="text" name="product-price" id="add-product-price" placeholder="Price" required>
                            <hr class="m-0">
                        </div>

                        <!-- Stock -->
                        <div class="w-100">
                            <label class="d-block" for="add-product-stock">Stock</label>
                            <input class="form-control p-1" type="number" name="product-stock" id="add-product-stock" placeholder="Quantity" required>
                            <hr class="m-0">
                        </div>

                        <!-- Short description -->
                        <div class="w-100">
                            <label class="d-block" for="add-product-short-description">Short description</label>
                            <textarea class="form-control p-1"  name="product-short-description" id="add-product-short-description" placeholder="Type something here..." required></textarea>
                            <hr class="m-0">
                        </div>

                        <!-- Detailed description -->
                        <div class="w-100">
                            <label class="d-block" for="add-product-detailed-description">Detailed description</label>
                            <textarea class="form-control p-1"  name="product-detailed-description" id="add-product-detailed-description" placeholder="Type something here..." required></textarea>
                            <hr class="m-0">
                        </div>

                        <!-- Specification -->
                        <div class="w-100">
                            <label class="d-block" for="add-product-specifications">Specifications</label>
                            <textarea class="form-control p-1"  name="product-specifications" id="add-product-specifications" placeholder="Type something here..." required></textarea>
                            <hr class="m-0">
                        </div>

                        <!-- Image link -->
                        <div class="w-100">
                            <label class="d-block" for="add-product-image">Image link</label>
                            <input class="form-control p-1" type="text" name="product-image" id="add-product-image" placeholder="Link" required>
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
    <!-- END OF BODY -->

    <!-- Footer -->
    <div id="footer">
        <?php include '../components/footer.php';?>
    </div>

    <!-- Bootstrap 5 -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
    <!-- Script for fixed navbar -->
    <script src="../../scripts/fixed_navbar.js"></script>
    <!-- Handle menu bar -->
    <script src="../../scripts/handle_menu.js"></script>
    <!-- Handle sign in-up -->
    <script src="../../scripts/user_data/handle_sign.js"></script>
    <!-- Product loader -->
    <script src="../../scripts/product_loader.js"></script>
    <!-- Admin controller  -->
    <script src="../../scripts/admin_data/admin_controller.js"></script>
    <!-- Handle adding product -->
    <script src="../../scripts/admin_data/add_product.js"></script>

</body>
</html>