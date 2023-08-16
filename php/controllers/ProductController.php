<?php

require_once './models/Product.php';
require_once './models/UserInfo.php';
require_once './models/Category.php';
require_once './models/ProductRating.php';
require_once './models/ProductComment.php';
require_once './models/ProductCategory.php';

class ProductController
{
    /////////////////////////////////////////////////////////////////////////////////////
    // Get Products
    /////////////////////////////////////////////////////////////////////////////////////
    public function getProducts($param, $data)
    {
        $queryParams = array();
        if (isset($_SERVER['QUERY_STRING'])) {
            $queryString = $_SERVER['QUERY_STRING'];
            parse_str($queryString, $queryParams);
        }

        try {
            $product = new Product();

            // Get product by name if exist
            $result = $product->get(
                $queryParams,
                ['name', 'max_price', 'min_price', 'category_id'],
                ['id', 'name', 'image_url', 'price', 'short_description', 'quantity', 'specs']
            );

            $rows = $result->fetchAll(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode(["message" => "Product List fetched", "data" => $rows]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::getProducts: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Get Product Detail
    /////////////////////////////////////////////////////////////////////////////////////
    public function getSingleProduct($param, $data)
    {
        try {
            $product = new Product();
            $productCategory = new ProductCategory();
            $productRating = new ProductRating();
            $productComment = new ProductComment();

            // Get product
            $result = $product->get(['id' => $param['id']], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Product does not exist"]);
                die();
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);

            // Get product category
            $result = $productCategory->get(['product_id' => $param['id']], ['product_id'], ['CATEGORY.id', 'CATEGORY.name']);
            $row['categories'] = $result->fetchAll(PDO::FETCH_ASSOC);

            // Get product comment
            $result = $productComment->get(['product_id' => $param['id']], ['product_id']);
            $row['comments'] = $result->fetchAll(PDO::FETCH_ASSOC);

            // Get rating number
            $result = $productRating->get(['product_id' => $param['id']], ['product_id'], ['AVG(rating) as rating_average', 'COUNT(rating) as rating_count']);
            $rating = $result->fetch(PDO::FETCH_ASSOC);
            $row['rating_average'] = $rating['rating_average'];
            $row['rating_count'] = $rating['rating_count'];

            http_response_code(200);
            echo json_encode(["message" => "Blog fetched", "data" => $row]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::getSingleProduct: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Create Product
    /////////////////////////////////////////////////////////////////////////////////////
    public function addProduct($param, $data)
    {
        // Checking body data
        if (
            !isset($data['name'])
            || !isset($data['short_description'])
            || !isset($data['description'])
            || !isset($data['price'])
            || !isset($data['quantity'])
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Missing name, short/detail desciption, price, or quantity"]);
            return;
        }

        try {
            $product = new Product();

            // Create product
            $result = $product->create(
                $data,
                ['name', 'short_description', 'description', 'image_url', 'price', 'quantity', 'specs']
            );

            http_response_code(200);
            echo json_encode(["message" => "Product created successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::addProduct: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Update Product
    /////////////////////////////////////////////////////////////////////////////////////
    public function updateProduct($param, $data)
    {
        try {
            // Check if product exist
            $product = new Product();

            // Check if product exist
            $result = $product->get(['id' => $param['id']], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Product does not exist"]);
                die();
            }

            // Update product
            $result = $product->update(
                $param['id'],
                $data,
                ['name', 'short_description', 'description', 'image_url', 'price', 'quantity', 'specs']
            );

            http_response_code(200);
            echo json_encode(["message" => "Product updated successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::updateProduct: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Product
    /////////////////////////////////////////////////////////////////////////////////////
    public function deleteProduct($param, $data)
    {
        try {
            $product = new Product();

            // Check if product exist
            $result = $product->get(['id' => $param['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Blog does not exist"]);
                die();
            }

            // Delete product
            $product->delete($param['id']);

            http_response_code(200);
            echo json_encode(["message" => "Product deleted successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::deleteProduct: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Comment Product
    /////////////////////////////////////////////////////////////////////////////////////
    public function commentProduct($param, $data)
    {
        // Checking body data
        if (
            !isset($data['content'])
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Missing content"]);
            return;
        }

        try {
            $product = new Product();
            $productComment = new ProductComment();
            $userInfo = new UserInfo();

            // Check if product exist
            $result = $product->get(['id' => $param['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Product does not exist"]);
                die();
            }

            // Check if user exist
            $result = $userInfo->get(['id' => $param['user']['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "User does not exist"]);
                die();
            }

            $data['product_id'] = $param['id'];
            $data['user_id'] = $param['user']['id'];


            // Create product comment
            $productComment->create(
                $data,
                ['product_id', 'user_id', 'content']
            );

            http_response_code(200);
            echo json_encode(["message" => "Product comment created successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::commentProduct: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Rate Product
    /////////////////////////////////////////////////////////////////////////////////////
    public function rateProduct($param, $data)
    {
        // Checking body data
        if (
            !isset($data['rating'])
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Missing stars"]);
            return;
        }

        try {
            $product = new Product();
            $productRating = new ProductRating();
            $userInfo = new UserInfo();

            // Check if product exist
            $result = $product->get(['id' => $param['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Product does not exist"]);
                die();
            }

            // Check if user exist
            $result = $userInfo->get(['id' => $param['user']['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "User does not exist"]);
                die();
            }

            // Check if user already rated
            $result = $productRating->get(['product_id' => $param['id'], 'user_id' => $param['user']['id']], ['product_id', 'user_id']);
            if ($result->rowCount() != 0) {
                http_response_code(400);
                echo json_encode(["message" => "User already rated this product"]);
                die();
            }

            $data['product_id'] = $param['id'];
            $data['user_id'] = $param['user']['id'];


            // Create product comment
            $productRating->create(
                $data,
                ['product_id', 'user_id', 'rating']
            );

            http_response_code(200);
            echo json_encode(["message" => "Product rating created successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::commentProduct: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Add Product Category
    /////////////////////////////////////////////////////////////////////////////////////
    public function addProductCategory($param, $data)
    {
        // Checking body data
        if (
            !isset($data['category_id'])
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Missing category_id"]);
            return;
        }

        try {
            $product = new Product();
            $category = new Category();
            $productCategory = new ProductCategory();

            // Check if product exist
            $result = $product->get(['id' => $param['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Product does not exist"]);
                die();
            }

            // Check if category exist
            $result = $category->get(['id' => $data['category_id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Category does not exist"]);
                die();
            }

            // Check if product already have this category
            $result = $productCategory->get(['product_id' => $param['id'], 'category_id' => $data['category_id']], ['product_id', 'category_id']);
            if ($result->rowCount() != 0) {
                http_response_code(400);
                echo json_encode(["message" => "Product already have this category"]);
                die();
            }

            $data['product_id'] = $param['id'];

            // Create product category
            $productCategory->create(
                $data,
                ['product_id', 'category_id']
            );

            http_response_code(200);
            echo json_encode(["message" => "Product category created successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::addProductCategory: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Product Category
    /////////////////////////////////////////////////////////////////////////////////////
    public function deleteProductCategory($param, $data)
    {
        // Checking body data
        if (
            !isset($data['category_id'])
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Missing category_id"]);
            return;
        }

        try {
            $product = new Product();
            $category = new Category();
            $productCategory = new ProductCategory();

            // Check if product exist
            $result = $product->get(['id' => $param['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Product does not exist"]);
                die();
            }

            // Check if category exist
            $result = $category->get(['id' => $data['category_id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Category does not exist"]);
                die();
            }

            $data['product_id'] = $param['id'];

            // Delete product category
            $productCategory->delete(
                $data['product_id'],
                $data['category_id']
            );

            http_response_code(200);
            echo json_encode(["message" => "Product category deleted successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in ProductController::deleteProductCategory: " . $e->getMessage();
            die();
        }
    }
}
