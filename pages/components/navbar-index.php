<!-- Navigation bar -->
<div class="big-navigation">
    <div class="navigation nav navbar navbar-expand-lg p-0 navbar-dark">

        <div class="container-fluid">

            <!-- Toggle button -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <!-- Navigation bar brand -->
            <a class="navbar-brand nav-img" href="./">
                <img src="../images/nav-img.png" height="100%" width="100%" alt="">
            </a>

            <!-- Other icons -->
            <a class="navbar-brand nav-icons d-flex justify-content-around me-0 d-lg-none d-flex">

                <svg class="d-md-block d-none" xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none" data-bs-toggle="collapse" data-bs-target="#search-fields">
                    <path d="M17.8674 15.7233H16.7381L16.3379 15.3373C17.7387 13.7078 18.582 11.5923 18.582 9.29102C18.582 4.15952 14.4225 0 9.29102 0C4.15952 0 0 4.15952 0 9.29102C0 14.4225 4.15952 18.582 9.29102 18.582C11.5923 18.582 13.7078 17.7387 15.3373 16.3379L15.7233 16.7381V17.8674L22.8702 25L25 22.8702L17.8674 15.7233ZM9.29102 15.7233C5.73185 15.7233 2.85878 12.8502 2.85878 9.29102C2.85878 5.73185 5.73185 2.85878 9.29102 2.85878C12.8502 2.85878 15.7233 5.73185 15.7233 9.29102C15.7233 12.8502 12.8502 15.7233 9.29102 15.7233Z" fill="white"/>
                </svg>
                

                <svg class="cart-btn" xmlns="http://www.w3.org/2000/svg" width="20" height="25" viewBox="0 0 20 25" fill="none" data-bs-toggle="collapse" data-bs-target="#cart-fields">
                    <path d="M17.5 5H15C15 2.2375 12.7625 0 10 0C7.2375 0 5 2.2375 5 5H2.5C1.125 5 0 6.125 0 7.5V22.5C0 23.875 1.125 25 2.5 25H17.5C18.875 25 20 23.875 20 22.5V7.5C20 6.125 18.875 5 17.5 5ZM10 2.5C11.375 2.5 12.5 3.625 12.5 5H7.5C7.5 3.625 8.625 2.5 10 2.5ZM17.5 22.5H2.5V7.5H5V10C5 10.6875 5.5625 11.25 6.25 11.25C6.9375 11.25 7.5 10.6875 7.5 10V7.5H12.5V10C12.5 10.6875 13.0625 11.25 13.75 11.25C14.4375 11.25 15 10.6875 15 10V7.5H17.5V22.5Z" fill="white"/>
                </svg>
            </a>

            <!-- Collapse items -->
            <div class="collapse navbar-collapse d-lg-flex justify-content-lg-around" id="navbarSupportedContent">

                <ul class="navbar-nav me-auto mb-2 mb-lg-0 gap-lg-5">
                    <!-- Home -->
                    <li class="nav-item">
                        <a class="nav-link fw-bold fs-4 text-light" aria-current="page" href="./index.php">Home</a>
                    </li>

                    <!-- Products -->
                    <li class="nav-item">
                        <a class="nav-link fw-bold fs-4 text-light" href="./pages/product.php">Products</a>
                    </li>

                    <!-- News -->
                    <li class="nav-item">
                        <a class="nav-link fw-bold fs-4 text-light" href="./pages/news.php">News</a>
                    </li>
                    
                    <!-- Support -->
                    <li class="nav-item">
                        <a class="nav-link fw-bold fs-4 text-light" href="#support">Support</a>
                    </li>

                    <!-- About -->
                    <li class="nav-item">
                        <a class="nav-link fw-bold fs-4 text-light" href="./pages/about.php">About</a>
                    </li>

                    <!-- Search icon -->
                    <li class="nav-item d-md-none d-sm-block d-flex">

                        <a class="nav-link d-inline-block p-0 m-0" href="#search">
                            <svg class="d-md-none d-sm-block" xmlns="http://www.w3.org/2000/svg" width="25" height="15" viewBox="0 0 25 25" fill="none">
                                <path class="search-icon" d="M17.8674 15.7233H16.7381L16.3379 15.3373C17.7387 13.7078 18.582 11.5923 18.582 9.29102C18.582 4.15952 14.4225 0 9.29102 0C4.15952 0 0 4.15952 0 9.29102C0 14.4225 4.15952 18.582 9.29102 18.582C11.5923 18.582 13.7078 17.7387 15.3373 16.3379L15.7233 16.7381V17.8674L22.8702 25L25 22.8702L17.8674 15.7233ZM9.29102 15.7233C5.73185 15.7233 2.85878 12.8502 2.85878 9.29102C2.85878 5.73185 5.73185 2.85878 9.29102 2.85878C12.8502 2.85878 15.7233 5.73185 15.7233 9.29102C15.7233 12.8502 12.8502 15.7233 9.29102 15.7233Z" fill="grey"/>
                            </svg>
                        </a>

                        <input class="ms-3 w-75 border-0 bg-black d-md-none d-sm-inline-block" type="text" placeholder="Searching on my website..." >
                        
                    </li>
                    
                </ul>

            </div>

            <!-- Other icons -->
            <a class="navbar-brand nav-icons d-flex justify-content-around me-0 d-none d-lg-flex">
                <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" viewBox="0 0 25 25" fill="none" data-bs-toggle="collapse" data-bs-target="#search-fields">
                    <path d="M17.8674 15.7233H16.7381L16.3379 15.3373C17.7387 13.7078 18.582 11.5923 18.582 9.29102C18.582 4.15952 14.4225 0 9.29102 0C4.15952 0 0 4.15952 0 9.29102C0 14.4225 4.15952 18.582 9.29102 18.582C11.5923 18.582 13.7078 17.7387 15.3373 16.3379L15.7233 16.7381V17.8674L22.8702 25L25 22.8702L17.8674 15.7233ZM9.29102 15.7233C5.73185 15.7233 2.85878 12.8502 2.85878 9.29102C2.85878 5.73185 5.73185 2.85878 9.29102 2.85878C12.8502 2.85878 15.7233 5.73185 15.7233 9.29102C15.7233 12.8502 12.8502 15.7233 9.29102 15.7233Z" fill="white"/>
                </svg>

                <svg class="cart-btn" xmlns="http://www.w3.org/2000/svg" width="20" height="25" viewBox="0 0 20 25" fill="none" data-bs-toggle="collapse" data-bs-target="#cart-fields">
                    <path d="M17.5 5H15C15 2.2375 12.7625 0 10 0C7.2375 0 5 2.2375 5 5H2.5C1.125 5 0 6.125 0 7.5V22.5C0 23.875 1.125 25 2.5 25H17.5C18.875 25 20 23.875 20 22.5V7.5C20 6.125 18.875 5 17.5 5ZM10 2.5C11.375 2.5 12.5 3.625 12.5 5H7.5C7.5 3.625 8.625 2.5 10 2.5ZM17.5 22.5H2.5V7.5H5V10C5 10.6875 5.5625 11.25 6.25 11.25C6.9375 11.25 7.5 10.6875 7.5 10V7.5H12.5V10C12.5 10.6875 13.0625 11.25 13.75 11.25C14.4375 11.25 15 10.6875 15 10V7.5H17.5V22.5Z" fill="white"/>
                </svg>
            </a>

        </div>
    </div>

    <!-- header -->
    <div class="header d-flex align-items-center justify-content-center p-2 d-md-none">
        <div class="header-content d-md-none">Free shipping on orders above 200$ (US only)</div>
    </div>

    <!-- Search fields -->
    <div class="search-fields collapse my-0 mx-auto position-relative" id="search-fields">
        <input class="w-100 bg-black border-0 p-3" type="text" placeholder="Searching on my website..." >
    </div>

    <!-- Cart fields -->
    <div class="cart-fields collapse my-0 mx-auto position-relative" id="cart-fields">
        <input class="w-100 bg-black border-0 p-3" type="text" placeholder="Log in my website..." >
    </div>

</div>