<?php
require_once './config/Database.php';

$connection = Database::getInstance()->getConnection();

class ProductComment
{
    public function get($queryParams, $allowedKeys = [])
    {
        global $connection;

        if (!empty($allowedKeys)) {
            $queryParams = array_intersect_key($queryParams, array_flip($allowedKeys));
        }

        $conditions = [];
        foreach ($queryParams as $key => $value) {
            $conditions[] = "$key='$value'";
        }
        $whereClause = !empty($conditions) ? 'WHERE ' . implode(' AND ', $conditions) : '';

        $query = "SELECT pc.id, pc.product_id, pc.user_id, pc.content, pc.created_at, ui.name as user_name, ui.image_url as user_avatar
        FROM PRODUCT_COMMENT as pc LEFT JOIN USER_INFO as ui ON pc.user_id = ui.id
        $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_COMMENT::get: " . $e->getMessage();
        }
    }

    public function create($data, $allowedKeys = [])
    {
        global $connection;

        if (!empty($allowedKeys)) {
            $data = array_intersect_key($data, array_flip($allowedKeys));
        }

        $keys = array_keys($data);
        $values = array_values($data);
        $query = "INSERT INTO PRODUCT_COMMENT (" . implode(", ", $keys) . ") VALUES ('" . implode("', '", $values) . "')";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_COMMENT::create: " . $e->getMessage();
        }
    }
}
