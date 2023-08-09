<?php
require_once './config/Database.php';

$connection = Database::getInstance()->getConnection();

class ProductCategory
{
    public function get($queryParams, $allowedKeys = [], $select = [])
    {
        global $connection;

        if (!empty($allowedKeys)) {
            $queryParams = array_intersect_key($queryParams, array_flip($allowedKeys));
        }

        $selectClause = empty($select) ? '*' : implode(', ', $select);

        $conditions = [];
        foreach ($queryParams as $key => $value) {
            $conditions[] = "$key='$value'";
        }
        $whereClause = !empty($conditions) ? 'WHERE ' . implode(' AND ', $conditions) : '';
        
        $query = "  SELECT $selectClause 
                    FROM PRODUCT_CATEGORY JOIN CATEGORY ON PRODUCT_CATEGORY.category_id = CATEGORY.id
                    $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_CATEGORY::get: " . $e->getMessage();
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
        $query = "INSERT INTO PRODUCT_CATEGORY (" . implode(", ", $keys) . ") VALUES ('" . implode("', '", $values) . "')";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_CATEGORY::create: " . $e->getMessage();
        }
    }

    public function update($id, $data, $allowedKeys = [])
    {
        global $connection;

        if (!empty($allowedKeys)) {
            $data = array_intersect_key($data, array_flip($allowedKeys));
        }

        foreach ($data as $key => $value) {
            $updates[] = "$key='$value'";
        }

        $query = "UPDATE PRODUCT_CATEGORY SET " . implode(", ", $updates) . " WHERE id='$id'";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_CATEGORY::update: " . $e->getMessage();
        }
    }

    public function delete($product_id, $category_id)
    {
        global $connection;

        $query = "DELETE FROM PRODUCT_CATEGORY WHERE product_id='$product_id' AND category_id='$category_id'";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_CATEGORY::delete: " . $e->getMessage();
        }
    }
}
