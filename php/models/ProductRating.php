<?php
require_once './config/Database.php';

$connection = Database::getInstance()->getConnection();

class ProductRating
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
        $query = "SELECT $selectClause FROM PRODUCT_RATING $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_RATING::get: " . $e->getMessage();
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
        $query = "INSERT INTO PRODUCT_RATING (" . implode(", ", $keys) . ") VALUES ('" . implode("', '", $values) . "')";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_RATING::create: " . $e->getMessage();
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

        $query = "UPDATE PRODUCT_RATING SET " . implode(", ", $updates) . " WHERE id='$id'";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_RATING::update: " . $e->getMessage();
        }
    }

    public function delete($id) {
        global $connection;

        $query = "DELETE FROM PRODUCT_RATING WHERE id='$id'";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in PRODUCT_RATING::delete: " . $e->getMessage();
        }
    }
}
