/*
 Navicat Premium Data Transfer

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80033 (8.0.33)
 Source Host           : localhost:3306
 Source Schema         : web-programming

 Target Server Type    : MySQL
 Target Server Version : 80033 (8.0.33)
 File Encoding         : 65001

 Date: 10/08/2023 16:39:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `author_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`author_id` ASC) USING BTREE,
  CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user_info` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for blog_comment
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `blog_id` int NOT NULL,
  `user_id` int NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `blog_id`(`blog_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `status` enum('BUYING','ORDERED','SHIPPING','DELIVERED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'BUYING',
  `ship_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `ordered_at` timestamp NULL DEFAULT NULL,
  `shipped_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cart_item
-- ----------------------------
DROP TABLE IF EXISTS `cart_item`;
CREATE TABLE `cart_item`  (
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT 0,
  `total_price` decimal(10, 2) NOT NULL DEFAULT 0.00,
  INDEX `cart_id`(`cart_id` ASC) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for cart_promotion
-- ----------------------------
DROP TABLE IF EXISTS `cart_promotion`;
CREATE TABLE `cart_promotion`  (
  `cart_id` int NOT NULL,
  `promotion_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`cart_id`, `promotion_code`) USING BTREE,
  INDEX `promotion_code`(`promotion_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `category_name_unique`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT 0,
  `short_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `specs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `product_name_unique`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for product_category
-- ----------------------------
DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category`  (
  `product_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`product_id`, `category_id`) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for product_comment
-- ----------------------------
DROP TABLE IF EXISTS `product_comment`;
CREATE TABLE `product_comment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for product_rating
-- ----------------------------
DROP TABLE IF EXISTS `product_rating`;
CREATE TABLE `product_rating`  (
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `rating` decimal(3, 1) NOT NULL,
  PRIMARY KEY (`user_id`, `product_id`) USING BTREE,
  INDEX `product_id`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for promotion
-- ----------------------------
DROP TABLE IF EXISTS `promotion`;
CREATE TABLE `promotion`  (
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `discount` decimal(5, 2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('INACTIVE','ACTIVE','EXPIRE') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'INACTIVE',
  PRIMARY KEY (`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` enum('ADMIN','USER') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'USER',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_email_unique`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info`  (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `birth_date` date NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `user_info_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Procedure structure for change_cart_item_price
-- ----------------------------
DROP PROCEDURE IF EXISTS `change_cart_item_price`;
delimiter ;;
CREATE PROCEDURE `change_cart_item_price`(IN cart_id INT, IN product_id INT)
BEGIN

        DECLARE pprice DECIMAL(10, 2) unsigned DEFAULT 0;
				SET pprice = ( SELECT price FROM product WHERE id = product_id );
        
        UPDATE cart_item 
        SET total_price = pprice * quantity
        WHERE cart_id = cart_id AND product_id = product_id;

    END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for change_cart_total_price
-- ----------------------------
DROP PROCEDURE IF EXISTS `change_cart_total_price`;
delimiter ;;
CREATE PROCEDURE `change_cart_total_price`(IN new_cart_id INT)
BEGIN
				DECLARE discount_amount DECIMAL ( 10, 2 ) DEFAULT 0;
        DECLARE original_price DECIMAL ( 10, 2 ) DEFAULT 0;
        
        SET discount_amount = (
            SELECT SUM( p.discount )
            FROM cart_promotion cp JOIN promotion p ON cp.promotion_code = p.CODE 
            WHERE cp.cart_id = new_cart_id AND p.STATUS = 'ACTIVE' );
        SET original_price = ( SELECT SUM( ci.total_price ) FROM cart_item ci WHERE ci.cart_id = new_cart_id );
				SET original_price = COALESCE(original_price, 0);
				SET discount_amount = COALESCE(discount_amount, 0);
        
        UPDATE cart
        SET total = original_price - discount_amount * 0.01 * original_price
        WHERE id = new_cart_id;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for checkout
-- ----------------------------
DROP PROCEDURE IF EXISTS `checkout`;
delimiter ;;
CREATE PROCEDURE `checkout`(IN new_cart_id INT)
BEGIN
		DECLARE `done` BOOL DEFAULT FALSE;
		DECLARE `pid` INT;
		DECLARE `pquantity` INT;
		DECLARE `cur1` CURSOR FOR 
            SELECT ci.product_id, ci.quantity
            FROM `cart_item` ci 
		    WHERE ci.cart_id = new_cart_id;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

		OPEN `cur1`;
		`cart_item_loop` :
		LOOP
			IF `done` THEN
				LEAVE `cart_item_loop`;
			END IF;

			FETCH `cur1` INTO `pid`, `pquantity`;
			
			UPDATE product
			SET quantity = quantity - pquantity
			WHERE id = pid;
			
			SET `pid` = 0;
			
		END LOOP `cart_item_loop`;
		CLOSE `cur1`;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for set_promotion_status
-- ----------------------------
DROP PROCEDURE IF EXISTS `set_promotion_status`;
delimiter ;;
CREATE PROCEDURE `set_promotion_status`()
BEGIN
		UPDATE promotion 
		SET status = 
			CASE
				WHEN CURDATE() < start_date then 'INACTIVE'
				WHEN CURDATE() >= start_date AND CURDATE() <= end_date THEN 'ACTIVE'
				ELSE 'EXPIRE'
			END;
END
;;
delimiter ;

-- ----------------------------
-- Event structure for update_promotion_status
-- ----------------------------
DROP EVENT IF EXISTS `update_promotion_status`;
delimiter ;;
CREATE EVENT `update_promotion_status`
ON SCHEDULE
EVERY '1' DAY STARTS '2023-08-05 09:37:45'
DO CALL set_promotion_status ()
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table cart_item
-- ----------------------------
DROP TRIGGER IF EXISTS `cart_item_insert_trigger`;
delimiter ;;
CREATE TRIGGER `cart_item_insert_trigger` BEFORE INSERT ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = NEW.quantity * pprice;
	END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table cart_item
-- ----------------------------
DROP TRIGGER IF EXISTS `cart_total_price_insert_trigger`;
delimiter ;;
CREATE TRIGGER `cart_total_price_insert_trigger` AFTER INSERT ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
	END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table cart_item
-- ----------------------------
DROP TRIGGER IF EXISTS `cart_item_update_trigger`;
delimiter ;;
CREATE TRIGGER `cart_item_update_trigger` BEFORE UPDATE ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = pprice * NEW.quantity; 
	END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table cart_item
-- ----------------------------
DROP TRIGGER IF EXISTS `cart_total_price_update_trigger`;
delimiter ;;
CREATE TRIGGER `cart_total_price_update_trigger` AFTER UPDATE ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
		
	END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table cart_item
-- ----------------------------
DROP TRIGGER IF EXISTS `cart_total_price_delete_trigger`;
delimiter ;;
CREATE TRIGGER `cart_total_price_delete_trigger` AFTER DELETE ON `cart_item` FOR EACH ROW BEGIN
			CALL change_cart_total_price ( OLD.cart_id );
	END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table product
-- ----------------------------
DROP TRIGGER IF EXISTS `product_update_trigger`;
delimiter ;;
CREATE TRIGGER `product_update_trigger` AFTER UPDATE ON `product` FOR EACH ROW BEGIN
		DECLARE `done` BOOL DEFAULT FALSE;
		DECLARE `cid` INT;
		DECLARE `cur1` CURSOR FOR 
            SELECT ci.cart_id 
            FROM `cart_item` ci 
		    WHERE ci.product_id = NEW.id;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

		OPEN `cur1`;
		`cart_item_loop` :
		LOOP
			IF `done` THEN
				LEAVE `cart_item_loop`;
			END IF;

			FETCH `cur1` INTO `cid`;
			CALL change_cart_item_price ( cid, NEW.id );
			CALL change_cart_total_price ( cid );
			
		END LOOP `cart_item_loop`;
		CLOSE `cur1`;
		
	END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
