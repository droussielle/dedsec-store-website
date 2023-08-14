<?php

require_once './models/Blog.php';
require_once './models/BlogComment.php';
require_once './models/UserInfo.php';


class BlogController
{
    /////////////////////////////////////////////////////////////////////////////////////
    // Get Blogs
    /////////////////////////////////////////////////////////////////////////////////////
    public function getBlogs($param, $data)
    {
        // Get query string
        $queryParams = array();
        if (isset($_SERVER['QUERY_STRING'])) {
            $queryString = $_SERVER['QUERY_STRING'];

            parse_str($queryString, $queryParams);
        }

        try {
            $blog = new Blog();

            // Get blogs by author or title if exist
            $result = $blog->get(
                $queryParams,
                ['author_id', 'author_name', 'title'],
                ['BLOG.id', 'title', 'author_id', 'content', 'BLOG.image_url', 'USER_INFO.name as author_name']
            );
            $rows = $result->fetchAll(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode(["message" => "Blog List fetched", "data" => $rows]);
        } catch (PDOException $e) {
            echo "Unknown error in BlogController::getBlogs: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Get Blog Detail
    /////////////////////////////////////////////////////////////////////////////////////
    public function getSingleBlog($param, $data)
    {
        try {
            $blog = new Blog();
            $userInfo = new UserInfo();
            $blogComment = new BlogComment();

            // Get blog
            $result = $blog->get(['id' => $param['id']], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Blog does not exist"]);
                die();
            }
            $row = $result->fetch(PDO::FETCH_ASSOC);

            // Get author
            $result = $userInfo->get(['id' => $row['author_id']], ['id'], ['id', 'name', 'image_url']);
            $author = $result->fetch(PDO::FETCH_ASSOC);
            $row['author_id'] = $author['id'];
            $row['author_name'] = $author['name'];
            $row['author_avatar'] = $author['image_url'];

            // Get blog comment
            $result = $blogComment->get(['blog_id' => $param['id']], ['blog_id']);
            $row['comments'] = $result->fetchAll(PDO::FETCH_ASSOC);

            http_response_code(200);
            echo json_encode(["message" => "Blog fetched", "data" => $row]);
        } catch (PDOException $e) {
            echo "Unknown error in BlogController::getSingleBlog: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Create Blog
    /////////////////////////////////////////////////////////////////////////////////////
    public function addBlog($param, $data)
    {
        // Checking body data
        if (
            !isset($data['title'])
            || !isset($data['content'])
        ) {
            http_response_code(400);
            echo json_encode(["message" => "Missing title or content"]);
            return;
        }

        try {
            $blog = new Blog();
            $userInfo = new UserInfo();

            // Fetch user from token
            $result = $userInfo->get(['id' => $param['user']['id']], ['id'], ['id', 'name', 'image_url']);
            $author = $result->fetch(PDO::FETCH_ASSOC);

            $data['user_id'] = $author['id'];

            // Create blog
            $result = $blog->create(
                $data,
                ['title', 'author_id', 'content', 'image_url']
            );

            http_response_code(200);
            echo json_encode(["message" => "Blog created successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in BlogController::addBlog: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Update Blog
    /////////////////////////////////////////////////////////////////////////////////////
    public function updateBlog($param, $data)
    {
        try {
            $blog = new Blog();

            // Check if blog exist
            $result = $blog->get(['id' => $param['id']], ['id'], ['BLOG.id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Blog does not exist"]);
                die();
            }

            // Update blog
            $blog->update(
                $param['id'],
                $data,
                ['title', 'content', 'image_url']
            );

            http_response_code(200);
            echo json_encode(["message" => "Blog updated successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in BlogController::addBlog: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Delete Blog
    /////////////////////////////////////////////////////////////////////////////////////
    public function deleteBlog($param, $data)
    {
        try {
            $blog = new Blog();

            // Check if blog exist
            $result = $blog->get(['id' => $param['id']], ['id'], ['BLOG.id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Blog does not exist"]);
                die();
            }

            // Delete blog
            $blog->delete($param['id']);

            http_response_code(200);
            echo json_encode(["message" => "Blog deleted successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in BlogController::addBlog: " . $e->getMessage();
            die();
        }
    }

    /////////////////////////////////////////////////////////////////////////////////////
    // Comment Blog
    /////////////////////////////////////////////////////////////////////////////////////
    public function commentBlog($param, $data)
    {
        // Checking body data
        if (!isset($data['content'])) {
            http_response_code(400);
            echo json_encode(["message" => "Missing content"]);
            return;
        }

        try {
            $blog = new Blog();
            $blogComment = new BlogComment();
            $userInfo = new UserInfo();

            // Check if blog exist
            $result = $blog->get(['id' => $param['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "Blog does not exist"]);
                die();
            }

            // Check if user exist
            $result = $userInfo->get(['id' => $param['user']['id']], ['id'], ['id']);
            if ($result->rowCount() == 0) {
                http_response_code(400);
                echo json_encode(["message" => "User does not exist"]);
                die();
            }

            $data['blog_id'] = $param['id'];
            $data['user_id'] = $param['user']['id'];

            // Create comment
            $blogComment->create(
                $data,
                ['blog_id', 'user_id', 'content']
            );

            http_response_code(200);
            echo json_encode(["message" => "Blog comment created successfully"]);
        } catch (PDOException $e) {
            echo "Unknown error in BlogController::commentBlog: " . $e->getMessage();
            die();
        }
    }
}
