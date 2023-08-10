-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 10, 2023 at 10:34 AM
-- Server version: 8.0.33
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web-programming`
--
-- CREATE DATABASE IF NOT EXISTS `web-programming` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
-- USE `web-programming`;

-- --------------------------------------------------------

--
-- Table structure for table `blog`
--

CREATE TABLE IF NOT EXISTS `blog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author_id` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`author_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `blog_comment`
--

CREATE TABLE IF NOT EXISTS `blog_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `blog_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `blog_id` (`blog_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE IF NOT EXISTS `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` enum('BUYING','ORDERED','SHIPPING','DELIVERED','REJECTED') NOT NULL DEFAULT 'BUYING',
  `ship_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `note` text,
  `ordered_at` timestamp NULL DEFAULT NULL,
  `shipped_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_item`
--

CREATE TABLE IF NOT EXISTS `cart_item` (
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `total_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  KEY `cart_id` (`cart_id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `cart_item`
--
DROP TRIGGER IF EXISTS `cart_item_insert_trigger`;
DELIMITER $$
CREATE TRIGGER `cart_item_insert_trigger` BEFORE INSERT ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = NEW.quantity * pprice;
	END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `cart_item_update_trigger`;
DELIMITER $$
CREATE TRIGGER `cart_item_update_trigger` BEFORE UPDATE ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = pprice * NEW.quantity; 
	END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `cart_total_price_delete_trigger`;
DELIMITER $$
CREATE TRIGGER `cart_total_price_delete_trigger` AFTER DELETE ON `cart_item` FOR EACH ROW BEGIN
			CALL change_cart_total_price ( OLD.cart_id );
	END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `cart_total_price_insert_trigger`;
DELIMITER $$
CREATE TRIGGER `cart_total_price_insert_trigger` AFTER INSERT ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
	END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `cart_total_price_update_trigger`;
DELIMITER $$
CREATE TRIGGER `cart_total_price_update_trigger` AFTER UPDATE ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
		
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart_promotion`
--

CREATE TABLE IF NOT EXISTS `cart_promotion` (
  `cart_id` int NOT NULL,
  `promotion_code` varchar(20) NOT NULL,
  PRIMARY KEY (`cart_id`,`promotion_code`),
  KEY `promotion_code` (`promotion_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE IF NOT EXISTS `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE IF NOT EXISTS `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `short_description` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Triggers `product`
--
DROP TRIGGER IF EXISTS `product_update_trigger`;
DELIMITER $$
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
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product_category`
--

CREATE TABLE IF NOT EXISTS `product_category` (
  `product_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`product_id`,`category_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_comment`
--

CREATE TABLE IF NOT EXISTS `product_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_rating`
--

CREATE TABLE IF NOT EXISTS `product_rating` (
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `rating` decimal(3,1) NOT NULL,
  PRIMARY KEY (`user_id`,`product_id`),
  KEY `product_id` (`product_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE IF NOT EXISTS `promotion` (
  `code` varchar(20) NOT NULL,
  `discount` decimal(5,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('INACTIVE','ACTIVE','EXPIRE') DEFAULT 'INACTIVE',
  PRIMARY KEY (`code`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER') NOT NULL DEFAULT 'USER',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE IF NOT EXISTS `user_info` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blog`
--
ALTER TABLE `blog`
  ADD CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user_info` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `blog_comment`
--
ALTER TABLE `blog_comment`
  ADD CONSTRAINT `blog_comment_ibfk_1` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `blog_comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_item`
--
ALTER TABLE `cart_item`
  ADD CONSTRAINT `cart_item_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cart_promotion`
--
ALTER TABLE `cart_promotion`
  ADD CONSTRAINT `cart_promotion_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_promotion_ibfk_2` FOREIGN KEY (`promotion_code`) REFERENCES `promotion` (`code`) ON DELETE CASCADE;

--
-- Constraints for table `product_category`
--
ALTER TABLE `product_category`
  ADD CONSTRAINT `product_category_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_category_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_comment`
--
ALTER TABLE `product_comment`
  ADD CONSTRAINT `product_comment_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `product_rating`
--
ALTER TABLE `product_rating`
  ADD CONSTRAINT `product_rating_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `product_rating_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_info`
--
ALTER TABLE `user_info`
  ADD CONSTRAINT `user_info_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE CASCADE;
COMMIT;



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
