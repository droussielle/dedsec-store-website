<?php

require_once './models/Category.php';

class CategoryController
{
    /////////////////////////////////////////////////////////////////////////////////////
    // Get Categorys
    /////////////////////////////////////////////////////////////////////////////////////
    public function getCategories($param, $data)
    {
        $queryParams = array();
        if (isset($_SERVER['QUERY_STRING'])) {
            $queryString = $_SERVER['QUERY_STRING'];

            parse_str($queryString, $queryParams);
        }

        try {
            $category = new Category();
            $result = $category->get($queryParams, [], []);
            $result = $result->fetchAll(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode(['message' => 'Category fetched', 'data' => $result]);
        } catch (PDOException $e) {
            echo "Unknown error in CategoryController::getCategories: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Add Category
    /////////////////////////////////////////////////////////////////////////////////////
    public function addCategory($param, $data)
    {
        // Checking if the data is valid
        if (
            !isset($data['name'])
        ) {
            http_response_code(400);
            echo json_encode(['message' => 'Missing name']);
            return;
        }

        try {
            $category = new Category();

            // Check if the Category already exists
            $result = $category->get($data, ['name'], []);
            if ($result->rowCount() > 0) {
                http_response_code(400);
                echo json_encode(['message' => 'Category already exists']);
                return;
            }

            // Create the Category
            $result = $category->create($data, ['name']);

            http_response_code(200);
            echo json_encode(['message' => 'Category created']);
        } catch (PDOException $e) {
            echo "Unknown error in CategoryController::addCategory: " . $e->getMessage();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Category
    /////////////////////////////////////////////////////////////////////////////////////
    public function deleteCategory($param, $data)
    {
        try {
            $category = new Category();

            // Check if the Category exists
            $result = $category->get($param, ['id'], []);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(['message' => 'Category does not exist']);
                return;
            }
            // Delete the Category
            $result = $category->delete($param['id']);

            http_response_code(200);
            echo json_encode(['message' => 'Category deleted']);
        } catch (PDOException $e) {
            echo "Unknown error in CategoryController::deleteCategory: " . $e->getMessage();
        }
    }
}
