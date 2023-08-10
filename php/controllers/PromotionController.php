<?php

require_once './models/Promotion.php';

class PromotionController
{
    /////////////////////////////////////////////////////////////////////////////////////
    // Get Promotions
    /////////////////////////////////////////////////////////////////////////////////////
    public function getPromotions($param, $data)
    {
        try {
            $promotion = new Promotion();
            $result = $promotion->get($data, [], []);
            $result = $result->fetchAll(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode(['message' => 'Promotion list fetched', 'data' => $result]);
        } catch (PDOException $e) {
            echo "Unknown error in PromotionController::getPromotions: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Add Promotions
    /////////////////////////////////////////////////////////////////////////////////////
    public function addPromotion($param, $data)
    {
        // Checking if the data is valid
        if (
            !isset($data['code'])
            || !isset($data['discount'])
            || !isset($data['start_date'])
            || !isset($data['end_date'])
        ) {
            http_response_code(400);
            echo json_encode(['message' => 'Missing data']);
            return;
        }

        try {
            $promotion = new Promotion();

            // Check if the promotion already exists
            $result = $promotion->get($data, ['code'], []);
            if ($result->rowCount() > 0) {
                http_response_code(400);
                echo json_encode(['message' => 'Promotion already exists']);
                return;
            }

            // Create the promotion
            $result = $promotion->create($data, ['code', 'discount', 'start_date', 'end_date']);

            http_response_code(200);
            echo json_encode(['message' => 'Promotion created']);
        } catch (PDOException $e) {
            echo "Unknown error in PromotionController::addPromotion: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Promotions
    /////////////////////////////////////////////////////////////////////////////////////
    public function deletePromotion($param, $data)
    {
        try {
            $promotion = new Promotion();

            // Check if the promotion exists
            $result = $promotion->get($param, ['code'], []);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(['message' => 'Promotion does not exist']);
                return;
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);
            if ($row['status'] != 'INACTIVE') {
                http_response_code(400);
                echo json_encode(['message' => 'Cant delete activated promotion, that is just wrong, legally']);
                return;
            }
            // Delete the promotion
            $result = $promotion->delete($param['code']);

            http_response_code(200);
            echo json_encode(['message' => 'Promotion deleted']);
        } catch (PDOException $e) {
            echo "Unknown error in PromotionController::deletePromotion: " . $e->getMessage();
        }
    }
}
