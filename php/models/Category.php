<?php
require_once './config/Database.php';

$connection = Database::getInstance()->getConnection();

class Category
{
    public function get($queryParams, $allowedKeys = [])
    {
        global $connection;

        if (!empty($allowedKeys)) {
            $queryParams = array_intersect_key($queryParams, array_flip($allowedKeys));
        }

        $selectClause = empty($select) ? '*' : implode(', ', $select);

        $conditions = [];
        foreach ($queryParams as $key => $value) {
            switch ($key):
                case 'name':
                    $conditions[] = "CATEGORY.name LIKE '%$value%'";
                    break;
                default:
                    $conditions[] = "$key='$value'";
            endswitch;
        }
        $whereClause = !empty($conditions) ? 'WHERE ' . implode(' AND ', $conditions) : '';
        
        $query = "SELECT $selectClause FROM CATEGORY $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CATEGORY::get: " . $e->getMessage();
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
        $query = "INSERT INTO CATEGORY (" . implode(", ", $keys) . ") VALUES ('" . implode("', '", $values) . "')";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CATEGORY::create: " . $e->getMessage();
        }
    }

    public function delete($id)
    {
        global $connection;

        $query = "DELETE FROM CATEGORY WHERE id='$id'";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CATEGORY::delete: " . $e->getMessage();
        }
    }
}
