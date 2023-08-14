<?php

require_once './models/User.php';
require_once './models/UserInfo.php';

use Firebase\JWT\JWT;

class AuthController
{

    public function register($param, $data)
    {
        // Checking body data
        if (!isset($data['name']) || !isset($data['password']) || !isset($data['email'])) {
            http_response_code(400);
            echo json_encode(["message" => "Missing email, password, or name, all other fields are optional"]);
            return;
        }
        // Validate the data
        $name = $data['name'];
        $email = $data['email'];
        $password = $data['password'];
        $image_url = $data['image_url'] ?? null;

        if (
            filter_var($email, FILTER_VALIDATE_EMAIL) === false
            || strlen($password) < 6
            || isset($data['phone']) && strlen($data['phone']) > 10
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Invalid email or password or image url"]);
            return;
        }

        try {
            $user = new User();
            $userInfo = new UserInfo();

            $result = $user->get(['email' => $email], ['email'], ['id', 'email']);

            // Check if email already exists
            if ($result->rowCount() > 0) {
                http_response_code(400);
                echo json_encode(["message" => "Email already exists"]);
                die();
            }
            // Hash password
            $password = password_hash($password, PASSWORD_BCRYPT);

            // Create user, then associated user_info
            $user->create(['email' => $email, 'password' => $password]);
            $newUserId = $user->get(['email' => $email], ['email'], ['id', 'role'])
                ->fetch(PDO::FETCH_ASSOC);
            $data['id'] = $newUserId['id'];
            $userInfo->create(
                $data,
                ['id', 'name', 'image_url', 'birth_date', 'phone', 'address']
            );

            // Create JWT
            $row = [
                'id' => $newUserId['id'],
                'email' => $email,
                'role' => $newUserId['role'],
            ];
            $jwt = JWT::encode($row, $_ENV['SECRECT_KEY'], 'HS256');

            // Attached data for client side
            $row['name'] = $name;
            $row['image_url'] = $image_url;

            http_response_code(200);
            echo json_encode(["message" => "User created successfully", "token" => $jwt, "data" => $row]);
        } catch (PDOException $e) {
            echo "Unknown error in AuthController::register: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Login
    /////////////////////////////////////////////////////////////////////////////////////
    public function login($param, $data)
    {
        // Checking body data
        if (!isset($data['password']) || !isset($data['email'])) {
            http_response_code(400);
            echo json_encode(["message" => "Missing email or password"]);
            return;
        }
        // Validate the data
        $email = $data['email'];
        $password = $data['password'];

        if (
            filter_var($email, FILTER_VALIDATE_EMAIL) === false
            || strlen($password) < 6
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Invalid email or password"]);
            return;
        }

        try {
            $user = new User();
            $userInfo = new UserInfo();

            $result = $user->get(['email' => $email], ['email'], ['id', 'email', 'password', 'role']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Account does not exist"]);
                die();
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);

            // Check password
            if (!password_verify($password, $row['password'])) {
                http_response_code(400);
                echo json_encode(["message" => "Wrong password"]);
                die();
            }

            // Attached data for client side
            $result = $userInfo->get(['id' => $row['id']], ['id'], ['name', 'image_url'])->fetch(PDO::FETCH_ASSOC);
            $result['id'] = $row['id'];
            $result['email'] = $row['email'];
            $result['role'] = $row['role'];

            // Create JWT
            unset($row['password']);
            $jwt = JWT::encode($row, $_ENV['SECRECT_KEY'], 'HS256');

            http_response_code(200);
            echo json_encode(["message" => "User login successfully", "token" => $jwt, "data" => $result]);
        } catch (PDOException $e) {
            echo "Unknown error in AuthController::register: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Change Profile
    /////////////////////////////////////////////////////////////////////////////////////
    public function changeProfile($param, $data)
    {
        try {
            $user = new User();
            $userInfo = new UserInfo();

            $id = $param['user']['id'];
            // Check if email already exists
            $result = $user->get(['id' => $id], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Account does not exist"]);
                die();
            }

            // Update user_info
            $userInfo->update($id, $data, ['name', 'image_url', 'birth_date', 'phone', 'address']);

            http_response_code(200);
            echo json_encode(["message" => "User profile updated successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in AuthController::changeProfile: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Change Password
    /////////////////////////////////////////////////////////////////////////////////////
    public function changePassword($param, $data)
    {
        // Checking body data
        if (
            !isset($data['newPassword']) || !isset($data['oldPassword'])
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Missing old password or new password"]);
            return;
        }

        if (
            strlen($data['newPassword']) < 6 || strlen($data['oldPassword']) < 6
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Old or new password must be at least 6 characters"]);
            return;
        }

        try {
            $user = new User();

            $id = $param['user']['id'];

            // Check if email already exists
            $result = $user->get(['id' => $id], ['id'], ['id', 'email', 'password', 'role']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Account does not exist"]);
                die();
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);

            // Check password
            if (!password_verify($data['oldPassword'], $row['password'])) {
                http_response_code(400);
                echo json_encode(["message" => "Wrong password"]);
                die();
            }

            // Hash password
            $data['newPassword'] = password_hash($data['newPassword'], PASSWORD_BCRYPT);

            // Update user_info
            $user->update($id, ['password' => $data['newPassword']], ['password']);

            http_response_code(200);
            echo json_encode(["message" => "User password updated successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in AuthController::changeProfile: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Self
    /////////////////////////////////////////////////////////////////////////////////////
    public function deleteSelf($param, $data)
    {
        try {
            $user = new User();

            $id = $param['user']['id'];
            // Check if email already exists
            $result = $user->get(['id' => $id], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Account does not exist"]);
                die();
            }

            // Delete user
            $user->delete($id);

            http_response_code(200);
            echo json_encode(["message" => "User deleted successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in AuthController::deleteSelf: " . $e->getMessage();
            die();
        }
    }
}
