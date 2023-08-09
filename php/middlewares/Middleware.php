<?php

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

require_once './models/User.php';
require_once  './models/UserInfo.php';

class Middleware
{
    public static function requireLogin(&$vars)
    {
        if (!isset($_SERVER['HTTP_AUTHORIZATION'])) {
            http_response_code(401);
            echo json_encode([
                "message" => "Authentication failed, please login"
            ]);
            die();
        }

        $token = $_SERVER['HTTP_AUTHORIZATION'];
        $key = $_SERVER['SECRECT_KEY'];

        try {
            $token = str_replace('Bearer ', '', $token);
            // Decode token from request
            $decoded = JWT::decode($token, new Key($key, 'HS256'));
            

            // Get email, role
            $user = new User();
            $result = $user->get(['id' => $decoded->id], ['id'], ['id', 'email', 'role']);
            if ($result->rowCount() == 0) {
                http_response_code(401);
                echo json_encode([
                    "message" => "Something's wrong with your token, please delete it and try again"
                ]);
                die();
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);

            // Check if token's data is outdated
            if (
                $row['email'] != $decoded->email ||
                $row['role'] != $decoded->role
            ) {
                http_response_code(401);
                echo json_encode([
                    "message" => "Token's data is outdated, please log in again"
                ]);
                die();
            }

            $vars['user'] = [
                'id' => $row['id'],
                'email' => $row['email'],
                'role' => $row['role']
            ];

            return $vars;
        } catch (Exception $e) {
            http_response_code(401);
            echo json_encode([
                "message" => "Something's wrong with your token, please delete it and try again"
            ]);
            die();
        }
    }

    public static function requireAdmin(&$vars)
    {
        Middleware::requireLogin($vars);
        if ($vars['user']['role'] != 'ADMIN') {
            http_response_code(403);
            echo json_encode([
                'message' => 'Forbidden request, please try to login with admin account'
            ]);
            die();
        }
    }
}
