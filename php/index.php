<?php
// Header configuration, do not touch
header('Content-Type: application/json');
// Front end server address
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Credentials: true');

// Fetch method and URI from request
$httpMethod = $_SERVER['REQUEST_METHOD'];
$uri = $_SERVER['REQUEST_URI'];


// Handle  CORS error
if ($httpMethod == "OPTIONS") {
    header("HTTP/1.1 200 OK");
    die();
}

// Load composer (PHP third party package manager)
require './vendor/autoload.php';

require_once './config/Database.php';

// Load .env variable
$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();


//Router function
$dispatcher = FastRoute\simpleDispatcher(function (FastRoute\RouteCollector $r) {
    function addController($controller, $func)
    {
        return $controller . "Controller/" . $func;
    }

    // Auth Group
    $r->addGroup('/{group:auth}', function (FastRoute\RouteCollector $r) {
        $r->addRoute('POST', '/register', 'register');
        $r->addRoute('POST', '/login', 'login');
        $r->addRoute('PATCH', '/password', ['requireLogin', 'changePassword']);
        $r->addRoute('PATCH', '/profile', ['requireLogin', 'changeProfile']);
        $r->addRoute('DELETE', '', ['requireLogin', 'deleteSelf']);
    });

    // Account Group
    $r->addGroup('/{group:user}', function (FastRoute\RouteCollector $r) {
        $r->addRoute('GET', '', ['requireAdmin', 'getUsers']);
        $r->addRoute('GET', '/{id:\d+}', ['requireLogin', 'getSingleUser']);
    });

    // Product Group
    $r->addGroup('/{group:product}', function (FastRoute\RouteCollector $r) {
        $r->addRoute('GET', '', 'getProducts');
        $r->addRoute('GET', '/{id:\d+}', 'getSingleProduct');
        $r->addRoute('POST', '', ['requireAdmin', 'addProduct']);
        $r->addRoute('PATCH', '/{id:\d+}', ['requireAdmin', 'updateProduct']);
        $r->addRoute('DELETE', '/{id:\d+}', ['requireAdmin', 'deleteProduct']);
        $r->addRoute('POST', '/{id:\d+}/comment', ['requireLogin', 'commentProduct']);
        $r->addRoute('POST', '/{id:\d+}/rate', ['requireLogin', 'rateProduct']);
        $r->addRoute('POST', '/{id:\d+}/category', ['requireAdmin', 'addProductCategory']);
        $r->addRoute('DELETE', '/{id:\d+}/category', ['requireAdmin', 'deleteProductCategory']);
    });

    // Category Group
    $r->addGroup('/{group:category}', function (FastRoute\RouteCollector $r) {
        $r->addRoute('GET', '', 'getCategories');
        $r->addRoute('POST', '', ['requireAdmin', 'addCategory']);
        $r->addRoute('DELETE', '/{id:\d+}', ['requireAdmin', 'deleteCategory']);
    });

    // Blog Group
    $r->addGroup('/{group:blog}', function (FastRoute\RouteCollector $r) {
        $r->addRoute('GET', '',  'getBlogs');
        $r->addRoute('GET', '/{id:\d+}', 'getSingleBlog');
        $r->addRoute('POST', '', ['requireAdmin', 'addBlog']);
        $r->addRoute('PATCH', '/{id:\d+}', ['requireAdmin', 'updateBlog']);
        $r->addRoute('DELETE', '/{id:\d+}', ['requireAdmin', 'deleteBlog']);
        $r->addRoute('POST', '/{id:\d+}/comment', ['requireLogin', 'commentBlog']);
    });

    // Promotion Group
    $r->addGroup('/{group:promotion}', function (FastRoute\RouteCollector $r) {
        $r->addRoute('GET', '', ['requireAdmin', 'getpromotions']);
        $r->addRoute('POST', '', ['requireAdmin', 'addPromotion']);
        $r->addRoute('DELETE', '/{code:\D+}', ['requireAdmin', 'deletePromotion']);
    });

    // Cart & Order Group Merge Into Cart Only
    $r->addGroup('/{group:cart}', function (FastRoute\RouteCollector $r) {
        $r->addRoute('GET', '', ['requireLogin', 'getCart']);
        $r->addRoute('GET', '/order', ['requireLogin', 'getOrders']);
        $r->addRoute('GET', '/order/{id:\d+}', ['requireLogin', 'getSingleOrder']);
        $r->addRoute('POST', '/product/{product_id:\d+}', ['requireLogin', 'addProductToCart']);
        $r->addRoute('PATCH', '/product/{product_id:\d+}', ['requireLogin', 'updateProductInCart']);
        $r->addRoute('DELETE', '/product/{product_id:\d+}', ['requireLogin', 'deleteProductInCart']);
        $r->addRoute('POST', '/promotion', ['requireLogin', 'addPromotionToCart']);
        $r->addRoute('DELETE', '/promotion/{code:\w+}', ['requireLogin', 'deletePromotionInCart']);
        $r->addRoute('POST', '/checkout', ['requireLogin', 'checkoutCart']);
        $r->addRoute('PATCH', '/order/{id:\d+}', ['requireAdmin', 'updateOrderStatus']);
    });
});


// Strip query string (?foo=bar) and decode URI
// To access query string, use $_GET['foo']
if (false !== $pos = strpos($uri, '?')) {
    $uri = substr($uri, 0, $pos);
}
$uri = rawurldecode($uri);


// Route handler
$routeInfo = $dispatcher->dispatch($httpMethod, $uri);
switch ($routeInfo[0]) {
    case FastRoute\Dispatcher::NOT_FOUND:
        http_response_code(404);
        echo json_encode(["message" => 'API NOT FOUND']);
        break;
    case FastRoute\Dispatcher::METHOD_NOT_ALLOWED:
        http_response_code(405);
        echo json_encode(["message" => 'Method is not allowed']);
        break;
    case FastRoute\Dispatcher::FOUND:
        $handler = $routeInfo[1];
        $vars = $routeInfo[2];
        $json = file_get_contents('php://input');
        $data = array();
        if (!empty($json)) {
            $data = json_decode($json, true);
        }

        // Call middleware
        include_once './middlewares/Middleware.php';

        foreach ((array) $handler as $function) {
            switch ($function) {
                case 'requireLogin':
                    Middleware::requireLogin($vars);
                    break;
                case 'requireAdmin':
                    Middleware::requireAdmin($vars);
                    break;
                default:
                    $controllerName = ucfirst($vars['group']) . 'Controller';
                    require './controllers/' . $controllerName . '.php';
                    $controller = new $controllerName();
                    $controller->$function($vars, $data);
                    break;
            }
        }
        break;
}
