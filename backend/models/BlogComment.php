<?php
require_once './config/Database.php';

$connection = Database::getInstance()->getConnection();

class BlogComment
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
        
        $query = "SELECT bc.id, bc.blog_id, bc.user_id, bc.content, bc.created_at, ui.name as user_name, ui.image_url as user_avatar
        FROM BLOG_COMMENT as bc LEFT JOIN USER_INFO as ui ON bc.user_id = ui.id 
        $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in BLOG_COMMENT::get: " . $e->getMessage();
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
        $query = "INSERT INTO BLOG_COMMENT (" . implode(", ", $keys) . ") VALUES ('" . implode("', '", $values) . "')";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in BLOG_COMMENT::create: " . $e->getMessage();
        }
    }
}
