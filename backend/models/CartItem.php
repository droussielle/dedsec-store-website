<?php
require_once './config/Database.php';

$connection = Database::getInstance()->getConnection();

class CartItem
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
            $conditions[] = "$key='$value'";
        }
        $whereClause = !empty($conditions) ? 'WHERE ' . implode(' AND ', $conditions) : '';
        $query = "SELECT $selectClause FROM CART_ITEM $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_ITEM::get: " . $e->getMessage();
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
        $query = "INSERT INTO CART_ITEM (" . implode(", ", $keys) . ") VALUES ('" . implode("', '", $values) . "')";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_ITEM::create: " . $e->getMessage();
        }
    }

    public function update($cart_id, $product_id, $data, $allowedKeys = [])
    {
        global $connection;

        if (!empty($allowedKeys)) {
            $data = array_intersect_key($data, array_flip($allowedKeys));
        }

        foreach ($data as $key => $value) {
            $updates[] = "$key='$value'";
        }

        $query = "UPDATE CART_ITEM SET " . implode(", ", $updates) . " 
                    WHERE cart_id='$cart_id' AND product_id='$product_id'";
        
        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_ITEM::update: " . $e->getMessage();
        }
    }

    public function delete($cart_id, $product_id)
    {
        global $connection;

        $query = "DELETE FROM CART_ITEM WHERE cart_id='$cart_id' AND product_id='$product_id'";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_ITEM::delete: " . $e->getMessage();
        }
    }

    public function getGeneralList($queryParams, $allowedKeys = [], $select = [])
    {
        global $connection;

        if (!empty($allowedKeys)) {
            $queryParams = array_intersect_key($queryParams, array_flip($allowedKeys));
        }

        $selectClause = empty($select) ? 'CART_ITEM.*' : implode(', ', $select);

        $conditions = [];
        foreach ($queryParams as $key => $value) {
            $conditions[] = "CART_ITEM.$key='$value'";
        }
        $whereClause = !empty($conditions) ? 'WHERE ' . implode(' AND ', $conditions) : '';

        $query = "  SELECT $selectClause, PRODUCT.name as product_name, PRODUCT.image_url as product_image 
                    FROM CART_ITEM JOIN PRODUCT ON CART_ITEM.product_id = PRODUCT.id 
                    $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_ITEM::getGeneralList: " . $e->getMessage();
        }
    }
}
