<?php

require_once './models/User.php';
require_once './models/UserInfo.php';

// Controller for Admin only, no need for more detail queries
class UserController
{
    /////////////////////////////////////////////////////////////////////////////////////
    // Get Users
    /////////////////////////////////////////////////////////////////////////////////////
    public function getUsers($param, $data)
    {
        try {
            $user = new User();
            $result = $user->getGeneralList();
            $result = $result->fetchAll(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode(['message' => 'User list fetched', 'data' => $result]);
        } catch (PDOException $e) {
            echo "Unknown error in UserController::getUsers: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Get User Detail
    /////////////////////////////////////////////////////////////////////////////////////
    public function getSingleUser($param, $data)
    {
        // Filter priviledge
        if ($param['user']['role'] != 'ADMIN' && $param['user']['id'] != $param['id']) {
            http_response_code(403);
            echo json_encode(['message' => 'Non-admin user can only get their own detail']);
            return;
        }

        try {
            $user = new User();
            $userInfo = new UserInfo();

            $result = $user->get(['id' => $param['id']], ['id'], ['id', 'role', 'email']);
            if ($result->rowCount() == 0) {
                http_response_code(404);
                echo json_encode(['message' => 'User not found']);
                return;
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);

            $result = $userInfo->get(
                ['id' => $row['id']],
                [],
                ['name', 'image_url', 'birth_date', 'phone', 'address']
            );
            $row['info'] = $result->fetch(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode(['message' => 'User detail fetched', 'data' => $row]);
        } catch (PDOException $e) {
            echo "Unknown error in UserController::getSingleUser: " . $e->getMessage();
        }
    }
}
