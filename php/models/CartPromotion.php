<?php
require_once './config/Database.php';

$connection = Database::getInstance()->getConnection();

class CartPromotion
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
            switch ($key):
                case 'discount':
                case 'status':
                    $conditions[] = "PROMOTION.$key='$value'";
                    break;
                default:
                    $conditions[] = "CART_PROMOTION.$key='$value'";
                    break;
            endswitch;
        }
        $whereClause = !empty($conditions) ? 'WHERE ' . implode(' AND ', $conditions) : '';
        $query = "SELECT $selectClause 
                    FROM CART_PROMOTION JOIN PROMOTION ON CART_PROMOTION.promotion_code = PROMOTION.code 
                    $whereClause";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_PROMOTION::get: " . $e->getMessage();
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
        $query = "INSERT INTO CART_PROMOTION (" . implode(", ", $keys) . ") VALUES ('" . implode("', '", $values) . "')";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_PROMOTION::create: " . $e->getMessage();
        }
    }

    public function delete($cart_id, $promotion_code)
    {
        global $connection;

        $query = "DELETE FROM CART_PROMOTION WHERE cart_id='$cart_id' AND promotion_code='$promotion_code'";

        try {
            $result = $connection->prepare($query);

            $result->execute();

            return $result;
        } catch (PDOException $e) {
            echo "Unknown error in CART_PROMOTION::delete: " . $e->getMessage();
        }
    }
}
