<?php

require_once './models/Cart.php';
require_once './models/Product.php';
require_once './models/CartItem.php';
require_once './models/Promotion.php';
require_once './models/CartPromotion.php';

class CartController
{
    /////////////////////////////////////////////////////////////////////////////////////
    // Get Current Cart
    /////////////////////////////////////////////////////////////////////////////////////
    public function getCart($param, $data)
    {
        try {
            $cart = new Cart();
            $cartItem = new CartItem();
            $cartPromotion = new CartPromotion();

            // Get current cart
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                ['user_id', 'status'],
                ['id', 'user_id', 'total']
            );
            if ($result->rowCount() == 0) {
                $result = $cart->create(['user_id' => $param['user']['id']], ['user_id']);
                $result = $cart->get(
                    ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                    ['user_id', 'status'],
                    []
                );
            }
            $cart = $result->fetch(PDO::FETCH_ASSOC);

            // Get cart items
            $result = $cartItem->getGeneralList(
                ['cart_id' => $cart['id']],
                ['cart_id', 'product_id', 'quantity'],
                []
            );
            $cart['items'] = $result->fetchAll(PDO::FETCH_ASSOC);

            // Get cart promotions
            $result = $cartPromotion->get(
                ['cart_id' => $cart['id']],
                ['cart_id'],
                ['promotion_code', 'discount', 'status']
            );
            $cart['promotions'] = $result->fetchAll(PDO::FETCH_ASSOC);

            $responseMessage = 'Cart retrieved successfully';
            if (in_array('EXPIRE', array_column($cart['promotions'], 'status'))) {
                $responseMessage .= ", warning: some promotions are expired and technically have no use in this cart's price, you can delete it or just let it be for research purpose";
            }

            http_response_code(200);
            echo json_encode(['message' => $responseMessage, 'data' => $cart]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::getCart: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Get Orders
    /////////////////////////////////////////////////////////////////////////////////////
    public function getOrders($param, $data)
    {
        try {
            $cart = new Cart();

            // Get orders
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status!' => 'BUYING'],
                ['user_id', 'status!'],
                []
            );
            if ($result->rowCount() > 0) {
                $cart = $result->fetch(PDO::FETCH_ASSOC);
            } else {
                $cart = [];
            }

            http_response_code(200);
            echo json_encode(['message' => 'Order list retrieved successfully', 'data' => $cart]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::getOrders: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Get Single Order
    /////////////////////////////////////////////////////////////////////////////////////
    public function getSingleOrder($param, $data)
    {
        try {
            $cart = new Cart();
            $cartItem = new CartItem();
            $cartPromotion = new CartPromotion();

            // Get order
            $result = $cart->get(
                ['id' => $param['id'], 'status!' => 'BUYING'],
                ['user_id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode(['message' => 'Order not found']);
                return;
            }
            $cart = $result->fetch(PDO::FETCH_ASSOC);

            if ($cart['user_id'] != $param['user']['id']) {
                http_response_code(403);
                echo json_encode(['message' => 'You are not allowed to access this order']);
                return;
            }

            // Get cart items
            $result = $cartItem->getGeneralList(
                ['cart_id' => $cart['id']],
                ['cart_id', 'product_id', 'quantity'],
                []
            );
            $cart['items'] = $result->fetchAll(PDO::FETCH_ASSOC);

            // Get cart promotions
            $result = $cartPromotion->get(
                ['cart_id' => $cart['id']],
                ['cart_id'],
                ['promotion_code', 'discount', 'status']
            );
            $cart['promotions'] = $result->fetchAll(PDO::FETCH_ASSOC);


            http_response_code(200);
            echo json_encode(['message' => 'Orders retrieved successfully', 'data' => $cart]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::getSingleOrder: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Add Product to Cart
    /////////////////////////////////////////////////////////////////////////////////////
    public function addProductToCart($param, $data)
    {
        // Checking body data
        if (!isset($data['quantity'])) {
            http_response_code(400);
            echo json_encode(['message' => 'Quantity is required']);
            die();
        }
        try {
            $cart = new Cart();
            $cartItem = new CartItem();

            // Get current cart
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                ['user_id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Cart not found, try to access the cart first"
                ]);
                die();
            }
            $cart = $result->fetch(PDO::FETCH_ASSOC);

            // Check if product exists
            $product = new Product();
            $result = $product->get(
                ['id' => $param['product_id']],
                ['id'],
                ['id', 'quantity']
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Product not found"
                ]);
                die();
            }
            $productQuantity = $result->fetch(PDO::FETCH_ASSOC)['quantity'];

            // Check if product already in cart, then check its quantity before adding
            $result = $cartItem->get(
                ['cart_id' => $cart['id'], 'product_id' => $param['product_id']],
                ['cart_id', 'product_id'],
                []
            );
            if ($result->rowCount() == 0) {
                if ($productQuantity < intval($data['quantity'])) {
                    http_response_code(400);
                    echo json_encode([
                        "message" => "Product quantity is not enough, try to reduce the amount you want to buy"
                    ]);
                    die();
                }

                $result = $cartItem->create(
                    [
                        'cart_id' => $cart['id'],
                        'product_id' => $param['product_id'],
                        'quantity' => $data['quantity']
                    ],
                    ['cart_id', 'product_id', 'quantity']
                );
            } else {
                // Update product quantity in cart
                $cartComponent = $result->fetch(PDO::FETCH_ASSOC);
                if ($productQuantity < $cartComponent['quantity'] + intval($data['quantity'])) {
                    http_response_code(400);
                    echo json_encode([
                        "message" => "Product quantity is not enough, try to reduce the amount you want to buy"
                    ]);
                    die();
                }

                $result = $cartItem->update(
                    $cartComponent['cart_id'],
                    $cartComponent['product_id'],
                    ['quantity' => $cartComponent['quantity'] + intval($data['quantity'])],
                    ['quantity']
                );
            }

            http_response_code(200);
            echo json_encode([
                "message" => "Product added to cart successfully"
            ]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::addProductToCart: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Update Product in Cart
    /////////////////////////////////////////////////////////////////////////////////////
    public function updateProductInCart($param, $data)
    {
        // Checking body data
        if (!isset($data['quantity'])) {
            echo 'Quantity is required';
            return;
        }
        try {
            $cart = new Cart();
            $cartItem = new CartItem();

            // Get current cart
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                ['user_id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Cart not found, try to access the cart first"
                ]);
            }
            $cart = $result->fetch(PDO::FETCH_ASSOC);

            // Check if product exists
            $product = new Product();
            $result = $product->get(
                ['id' => $param['product_id']],
                ['id'],
                ['id', 'quantity']
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Product not found"
                ]);
                die();
            }
            $productQuantity = $result->fetch(PDO::FETCH_ASSOC)['quantity'];
            if ($productQuantity < intval($data['quantity'])) {
                http_response_code(400);
                echo json_encode([
                    "message" => "Product quantity is not enough, try to reduce the amount you want to buy"
                ]);
                die();
            }

            // Check if product already in cart
            $result = $cartItem->get(
                ['cart_id' => $cart['id'], 'product_id' => $param['product_id']],
                ['cart_id', 'product_id'],
                []
            );
            if ($result->rowCount() == 0) {
                // Add new product to cart
                http_response_code(404);
                echo json_encode([
                    "message" => "Product not found in cart, try to access the cart first"
                ]);
            }

            // Update product quantity in cart
            $cartComponent = $result->fetch(PDO::FETCH_ASSOC);
            $result = $cartItem->update(
                $cartComponent['cart_id'],
                $cartComponent['product_id'],
                ['quantity' => $data['quantity']],
                ['quantity']
            );

            http_response_code(200);
            echo json_encode([
                "message" => "Product quantity changed successfully"
            ]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::addProductToCart: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Product in Cart
    /////////////////////////////////////////////////////////////////////////////////////
    public function deleteProductInCart($param, $data)
    {
        try {
            $cart = new Cart();
            $cartItem = new CartItem();

            // Get current cart
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                ['user_id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Cart not found, try to access the cart first"
                ]);
                die();
            }
            $cart = $result->fetch(PDO::FETCH_ASSOC);

            // Check if product already in cart
            $result = $cartItem->get(
                ['cart_id' => $cart['id'], 'product_id' => $param['product_id']],
                ['cart_id', 'product_id'],
                []
            );
            if ($result->rowCount() == 0) {
                // Add new product to cart
                http_response_code(404);
                echo json_encode([
                    "message" => "Product not found in cart"
                ]);
                die();
            }

            // Delete product in cart
            $result = $cartItem->delete($cart['id'], $param['product_id']);

            http_response_code(200);
            echo json_encode([
                "message" => "Product in cart deleted successfully"
            ]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::addProductToCart: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Add Promotion to Cart
    /////////////////////////////////////////////////////////////////////////////////////
    public function addPromotionToCart($param, $data)
    {
        // Checking body data
        if (!isset($data['code'])) {
            echo 'Promotion code is required';
            return;
        }

        try {
            $cart = new Cart();
            $promotion = new Promotion();
            $cartPromotion = new CartPromotion();

            // Get current cart
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                ['user_id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Cart not found, try to access the cart first"
                ]);
                die();
            }
            $cart = $result->fetch(PDO::FETCH_ASSOC);

            // Get promotion
            $result = $promotion->get(
                ['code' => $data['code'], 'status' => 'ACTIVE'],
                ['code', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Promotion not exist or already expired, try another"
                ]);
                die();
            }
            $promotion = $result->fetch(PDO::FETCH_ASSOC);
            if ($promotion['status'] == 'INACTIVE') {
                http_response_code(400);
                echo json_encode([
                    "message" => "Promotion is inactive or expire, try another"
                ]);
                die();
            }

            // Check if promotion already in cart
            $result = $cartPromotion->get(
                ['cart_id' => $cart['id'], 'promotion_code' => $promotion['code']],
                ['cart_id', 'promotion_code'],
                []
            );
            if ($result->rowCount() == 0) {
                // Add new promotion to cart
                $result = $cartPromotion->create(
                    [
                        'cart_id' => $cart['id'],
                        'promotion_code' => $promotion['code']
                    ],
                    ['cart_id', 'promotion_code']
                );
            } else {
                http_response_code(400);
                echo json_encode([
                    "message" => "Promotion already in cart"
                ]);
                die();
            }

            http_response_code(200);
            echo json_encode([
                "message" => "Promotion added to cart successfully"
            ]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::addPromotionToCart: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Promotion to Cart
    /////////////////////////////////////////////////////////////////////////////////////
    public function deletePromotionInCart($param, $data)
    {
        try {
            $cart = new Cart();
            $promotion = new Promotion();
            $cartPromotion = new CartPromotion();

            // Get current cart
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                ['user_id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Cart not found, try to access the cart first"
                ]);
                die();
            }
            $cart = $result->fetch(PDO::FETCH_ASSOC);

            // Get promotion
            $result = $promotion->get(
                ['code' => $param['code']],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Promotion not found"
                ]);
                die();
            }
            $promotion = $result->fetch(PDO::FETCH_ASSOC);

            // Check if promotion already in cart
            $result = $cartPromotion->get(
                ['cart_id' => $cart['id'], 'promotion_code' => $promotion['code']],
                ['cart_id', 'promotion_code'],
                []
            );
            if ($result->rowCount() != 0) {
                // Delete the promotion in cart
                $result = $cartPromotion->delete($cart['id'], $promotion['code']);
            } else {
                http_response_code(400);
                echo json_encode([
                    "message" => "Promotion is not in cart"
                ]);
                die();
            }

            http_response_code(200);
            echo json_encode([
                "message" => "Promotion in cart deleted successfully"
            ]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::addPromotionToCart: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Checkout Cart <==> Change Cart Status
    /////////////////////////////////////////////////////////////////////////////////////
    public function checkoutCart($param, $data)
    {
        // Check body data
        if (!isset($data['ship_address']) || isset($data['status'])) {
            echo json_encode(['message' => 'Address is required']);
            die();
        }
        try {
            $cart = new Cart();

            // Get current cart
            $result = $cart->get(
                ['user_id' => $param['user']['id'], 'status' => 'BUYING'],
                ['user_id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Cart not found, try to access the cart first"
                ]);
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);

            // Update cart status
            $data['status'] = "ORDERED";
            $result = $cart->update(
                $row['id'],
                $data,
                ['status', 'ship_address', 'note']
            );
            
            // Product quantity reduction function is called in the stored procedure
            $result = $cart->checkout($row['id']);

            http_response_code(200);
            echo json_encode([
                "message" => "Checkout success, order is being delivered"
            ]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::checkoutCart: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Update Order Shipping Status
    /////////////////////////////////////////////////////////////////////////////////////
    public function updateOrderStatus($param, $data)
    {
        // Check body data
        if (!isset($data['status'])) {
            http_response_code(200);
            echo json_encode(['message' => 'Status is required']);
            die();
        }
        try {
            $cart = new Cart();

            // Get current cart
            $result = $cart->get(
                ['id' => $param['id'], 'status!' => 'BUYING'],
                ['id', 'status'],
                []
            );
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode([
                    "message" => "Cart not found"
                ]);
            }

            $result = $cart->update(
                $param['id'],
                $data,
                ['status', 'ship_address', 'note']
            );

            http_response_code(200);
            echo json_encode([
                "message" => "Order updated successfully"
            ]);
        } catch (PDOException $e) {
            echo "Unknown error in CART::updateOrderStatus: " . $e->getMessage();
        }
    }
}
