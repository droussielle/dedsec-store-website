-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Aug 12, 2023 at 11:45 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web-programming-test`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `change_cart_item_price` (IN `cart_id` INT, IN `product_id` INT)   BEGIN

        DECLARE pprice DECIMAL(10, 2) unsigned DEFAULT 0;
				SET pprice = ( SELECT price FROM product WHERE id = product_id );
        
        UPDATE cart_item 
        SET total_price = pprice * quantity
        WHERE cart_id = cart_id AND product_id = product_id;

    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `change_cart_total_price` (IN `new_cart_id` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkout` (IN `new_cart_id` INT)   BEGIN
		DECLARE `done` BOOL DEFAULT FALSE;
		DECLARE `pid` INT;
		DECLARE `pquantity` INT;
		DECLARE `cur1` CURSOR FOR 
            SELECT ci.product_id, ci.quantity
            FROM `cart_item` ci 
		    WHERE ci.cart_id = new_cart_id;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

		OPEN `cur1`;
		`cart_item_loop` :		LOOP
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `set_promotion_status` ()   BEGIN
		UPDATE promotion 
		SET status = 
			CASE
				WHEN CURDATE() < start_date then 'INACTIVE'
				WHEN CURDATE() >= start_date AND CURDATE() <= end_date THEN 'ACTIVE'
				ELSE 'EXPIRE'
			END;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `blog`
--

CREATE TABLE `blog` (
  `id` int(11) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `blog`
--

INSERT INTO `blog` (`id`, `author_id`, `title`, `content`, `image_url`, `created_at`, `updated_at`) VALUES
(1, 2, 'Phone news 1', ' Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris vehicula massa sed arcu pulvinar, ac accumsan lectus accumsan. Quisque tempor mi lacus. Nam fermentum libero eget nulla venenatis iaculis. Quisque eget lorem eget ex ultrices condimentum et volutpat metus. Proin posuere, neque vel tempor tristique, mi augue rhoncus sapien, quis feugiat purus metus ut mauris. Ut ac diam dolor. Donec pulvinar egestas consectetur. Praesent id mauris sed massa consequat viverra sed nec turpis. Pellentesque magna magna, suscipit eget laoreet non, suscipit eget neque. Nam varius justo sem, nec bibendum mi sollicitudin egestas. Quisque pharetra risus vel libero egestas ultricies quis nec mauris. Donec ultricies euismod nunc et auctor.\n\nCras sed orci nibh. Cras faucibus sollicitudin felis. Donec a orci a mi ullamcorper semper. Proin dapibus, lacus quis vestibulum consectetur, metus dolor cursus purus, vitae convallis nibh metus ac ex. Ut vel purus eget tortor auctor scelerisque sed feugiat quam. Sed sed neque sagittis, accumsan eros ac, porta turpis. Proin hendrerit tortor feugiat eros faucibus facilisis. Duis iaculis nisl at varius hendrerit. Nullam sodales tincidunt neque tempor bibendum. Fusce sodales viverra diam, at rhoncus nisl porttitor eu. Nam eget velit fermentum, varius justo non, maximus diam. Phasellus nibh lectus, porttitor quis auctor sit amet, rhoncus eu augue. Integer fringilla mattis orci a aliquam. Nunc sit amet elementum enim. ', '/images/blogs/image1.png', '2023-08-12 08:36:16', '2023-08-12 09:14:22'),
(2, NULL, 'Phone news 2', ' Proin posuere ipsum a tincidunt congue. Aenean tristique, risus et venenatis ornare, tellus augue gravida velit, vel scelerisque sapien nulla ac velit. Mauris sollicitudin justo est, placerat laoreet tortor cursus id. Aliquam erat volutpat. Etiam sit amet est metus. Aenean interdum erat a massa sodales, ut venenatis orci lobortis. Vivamus sit amet lacinia urna. Curabitur maximus sed ante id tincidunt. Vestibulum sagittis dolor orci, ut eleifend leo porttitor ac. Pellentesque sed aliquam velit.\r\n\r\nAliquam luctus feugiat urna, sed vehicula turpis efficitur sodales. Phasellus tristique gravida justo, vitae elementum nulla commodo at. Proin magna tellus, tincidunt at volutpat vel, pellentesque at diam. Nunc pulvinar faucibus mi a auctor. Nam diam lectus, gravida sit amet cursus at, volutpat suscipit libero. Maecenas pulvinar sodales dolor, nec imperdiet nibh porta et. Integer malesuada suscipit finibus. Praesent leo nisi, interdum at tristique vel, rutrum quis ex. Sed posuere, elit vel ultricies pulvinar, ex tortor mollis sapien, vitae rutrum nibh sem in nunc. Quisque ultrices nisi magna, ac malesuada nisl facilisis in. Nulla molestie libero aliquet orci aliquam auctor. Integer tempus id quam sed ullamcorper. ', '/images/blogs/image2.jpg', '2023-08-12 09:15:45', '2023-08-12 09:15:45'),
(3, NULL, 'Phone news 3', ' Donec quis enim luctus, ultrices dui sit amet, dignissim mi. Mauris vestibulum lacus urna, ut auctor eros faucibus non. Aenean ac nulla lorem. Quisque hendrerit nibh ac mi tempus bibendum. Integer bibendum, quam ac porta dapibus, orci sem malesuada quam, ac rhoncus nibh nisl quis libero. Nullam nibh nibh, venenatis nec hendrerit nec, luctus lacinia urna. Praesent ex sapien, imperdiet sed lobortis ut, congue quis erat. Nulla volutpat tortor orci, quis finibus purus sollicitudin non. Mauris ac ante et orci lacinia mollis ut eu nibh. Mauris tempor molestie placerat. Curabitur molestie justo a eros ullamcorper condimentum. Praesent quis sem venenatis, ornare enim eget, vestibulum augue. Mauris at convallis ipsum. Sed at bibendum dolor, ut dictum nisl. Aliquam id venenatis mi. Sed mollis rhoncus sem, sed sodales nisi fermentum eget.\r\n\r\nUt ultricies vitae ligula sit amet iaculis. Phasellus convallis gravida fermentum. Fusce semper lectus quis cursus bibendum. Donec bibendum quam enim, vitae tempus tortor tincidunt vitae. Aliquam vitae facilisis neque, et tincidunt turpis. Duis cursus nisl viverra lectus tincidunt, tincidunt iaculis enim pellentesque. Nulla feugiat quam et metus sodales cursus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin nec eros mi. Vivamus pretium vestibulum vehicula. Donec non tincidunt augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Donec nec mi dapibus, malesuada sapien nec, faucibus libero. ', '/images/blogs/image1.png', '2023-08-12 09:16:14', '2023-08-12 09:16:14'),
(4, NULL, 'Phone news 4', ' Vivamus ullamcorper felis urna, non dapibus felis congue id. Duis pulvinar dignissim lorem vitae mattis. Curabitur aliquet vulputate nibh, vitae porta sem accumsan vel. Fusce non orci sed mauris malesuada condimentum vitae vel dolor. Duis pretium ex vitae dolor scelerisque luctus. Morbi finibus, mi eu consectetur sagittis, felis sem auctor leo, ac luctus lacus risus eu nisi. Proin id nibh sagittis, semper magna vitae, pellentesque nibh. Praesent eleifend lobortis posuere. Morbi placerat erat sed tortor sagittis, ac vulputate neque fermentum. Ut at mollis lorem. Maecenas porttitor arcu sapien, a aliquam augue vulputate ut. Donec sem diam, sodales in pellentesque id, auctor cursus velit. Sed pretium felis vitae massa mollis aliquam. Sed vitae posuere diam. Aliquam ultrices molestie arcu.\r\n\r\nDonec vitae tortor elementum, scelerisque nunc sit amet, malesuada ante. Etiam finibus gravida sapien ac ullamcorper. Donec dapibus orci semper vehicula aliquam. Pellentesque iaculis ante at tincidunt pharetra. Aliquam erat volutpat. Nunc maximus, lectus pellentesque euismod dapibus, nulla elit pretium sapien, ac tincidunt nisi eros et nisl. Cras faucibus est nec facilisis dictum. Etiam eget mauris placerat, consequat mi vel, ultrices libero. Donec non mi tincidunt, fringilla sem quis, maximus orci. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eu lectus sit amet felis blandit fringilla. Vestibulum sed nunc a libero ultrices placerat eu in ex.\r\n\r\nAenean aliquam lacus sagittis sapien vulputate dapibus quis non ex. Morbi blandit mauris in ex euismod, et lobortis libero sagittis. Quisque bibendum convallis lectus vel vehicula. Nam a est nibh. Nam auctor ante sit amet sapien hendrerit vehicula. Ut id elementum lacus. Phasellus lacinia consectetur blandit. Fusce placerat quam et laoreet faucibus.\r\n\r\n', '/images/blogs/image2.jpg', '2023-08-12 09:16:36', '2023-08-12 09:16:36');

-- --------------------------------------------------------

--
-- Table structure for table `blog_comment`
--

CREATE TABLE `blog_comment` (
  `id` int(11) NOT NULL,
  `blog_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('BUYING','ORDERED','SHIPPING','DELIVERED','REJECTED') NOT NULL DEFAULT 'BUYING',
  `ship_address` varchar(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `ordered_at` timestamp NULL DEFAULT NULL,
  `shipped_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cart_item`
--

CREATE TABLE `cart_item` (
  `cart_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Triggers `cart_item`
--
DELIMITER $$
CREATE TRIGGER `cart_item_insert_trigger` BEFORE INSERT ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = NEW.quantity * pprice;
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cart_item_update_trigger` BEFORE UPDATE ON `cart_item` FOR EACH ROW BEGIN
			DECLARE pprice INT unsigned DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = pprice * NEW.quantity; 
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cart_total_price_delete_trigger` AFTER DELETE ON `cart_item` FOR EACH ROW BEGIN
			CALL change_cart_total_price ( OLD.cart_id );
	END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cart_total_price_insert_trigger` AFTER INSERT ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
	END
$$
DELIMITER ;
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

CREATE TABLE `cart_promotion` (
  `cart_id` int(11) NOT NULL,
  `promotion_code` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `image_url` varchar(255) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `short_description` text NOT NULL,
  `specs` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `image_url`, `quantity`, `short_description`, `specs`) VALUES
(1, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series)', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/image1.png', 0, 'Extremely modular design with upgradable components\r\nComes with DMA Ryzen™ 7040 Series and 13th Gen ENTEL®\r\nOut-of-box compatibility with most Linux distros', '{\r\n   \"Processor options\": [\r\n      \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\",\r\n      \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\",\r\n      \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ],\r\n   \"Memory options\": [\r\n      \"DDR5-5600 - 8GB (1 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (2 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (1 x 16GB)\",\r\n      \"DDR5-5600 - 32GB (1 x 32GB)\",\r\n      \"DDR5-5600 - 32GB (2 x 16GB)\",\r\n      \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ],\r\n   \"Storage options\": [\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 250GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ],\r\n   \"Graphics\": [\r\n      \"Radeon™ 700M Graphics\",\r\n      \"ENTEL® Iris™ XP\"\r\n   ],\r\n   \"Display\": [\r\n      \"13.5” 3:2 2256*1504px \",\r\n      \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n      \"Available in matte and glossy covers\"\r\n   ],\r\n   \"Battery\": [\r\n      \"55Wh\",\r\n      \"61Wh\"\r\n   ],\r\n   \"Operating system\": [\r\n      \"Michealsoft Door 11 Home\",\r\n      \"Michealsoft Door 11 Pro\",\r\n      \"DEDSEC ctOS Workstation\",\r\n      \"None (bring your own) - Check out our recommended Linux distros\"\r\n   ]\r\n}'),
(2, 'DEDSEC Laptop 13 (ENTEL® Core™ 13th Gen)', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/image1.png', 0, 'Extremely modular design with upgradable components\r\nComes with DMA Ryzen™ 7040 Series and 13th Gen ENTEL®\r\nOut-of-box compatibility with most Linux distros', '{\r\n   \"Processor options\": [\r\n      \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\",\r\n      \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\",\r\n      \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ],\r\n   \"Memory options\": [\r\n      \"DDR5-5600 - 8GB (1 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (2 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (1 x 16GB)\",\r\n      \"DDR5-5600 - 32GB (1 x 32GB)\",\r\n      \"DDR5-5600 - 32GB (2 x 16GB)\",\r\n      \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ],\r\n   \"Storage options\": [\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 250GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ],\r\n   \"Graphics\": [\r\n      \"Radeon™ 700M Graphics\",\r\n      \"ENTEL® Iris™ XP\"\r\n   ],\r\n   \"Display\": [\r\n      \"13.5” 3:2 2256*1504px \",\r\n      \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n      \"Available in matte and glossy covers\"\r\n   ],\r\n   \"Battery\": [\r\n      \"55Wh\",\r\n      \"61Wh\"\r\n   ],\r\n   \"Operating system\": [\r\n      \"Michealsoft Door 11 Home\",\r\n      \"Michealsoft Door 11 Pro\",\r\n      \"DEDSEC ctOS Workstation\",\r\n      \"None (bring your own) - Check out our recommended Linux distros\"\r\n   ]\r\n}'),
(5, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series) 2', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/image1.png', 0, 'Extremely modular design with upgradable components\r\nComes with DMA Ryzen™ 7040 Series and 13th Gen ENTEL®\r\nOut-of-box compatibility with most Linux distros', '{\r\n   \"Processor options\": [\r\n      \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\",\r\n      \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\",\r\n      \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ],\r\n   \"Memory options\": [\r\n      \"DDR5-5600 - 8GB (1 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (2 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (1 x 16GB)\",\r\n      \"DDR5-5600 - 32GB (1 x 32GB)\",\r\n      \"DDR5-5600 - 32GB (2 x 16GB)\",\r\n      \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ],\r\n   \"Storage options\": [\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 250GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ],\r\n   \"Graphics\": [\r\n      \"Radeon™ 700M Graphics\",\r\n      \"ENTEL® Iris™ XP\"\r\n   ],\r\n   \"Display\": [\r\n      \"13.5” 3:2 2256*1504px \",\r\n      \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n      \"Available in matte and glossy covers\"\r\n   ],\r\n   \"Battery\": [\r\n      \"55Wh\",\r\n      \"61Wh\"\r\n   ],\r\n   \"Operating system\": [\r\n      \"Michealsoft Door 11 Home\",\r\n      \"Michealsoft Door 11 Pro\",\r\n      \"DEDSEC ctOS Workstation\",\r\n      \"None (bring your own) - Check out our recommended Linux distros\"\r\n   ]\r\n}'),
(6, 'DEDSEC Laptop 13 (ENTEL® Core™ 13th Gen) 2', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/image1.png', 0, 'Extremely modular design with upgradable components\r\nComes with DMA Ryzen™ 7040 Series and 13th Gen ENTEL®\r\nOut-of-box compatibility with most Linux distros', '{\r\n   \"Processor options\": [\r\n      \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\",\r\n      \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\",\r\n      \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ],\r\n   \"Memory options\": [\r\n      \"DDR5-5600 - 8GB (1 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (2 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (1 x 16GB)\",\r\n      \"DDR5-5600 - 32GB (1 x 32GB)\",\r\n      \"DDR5-5600 - 32GB (2 x 16GB)\",\r\n      \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ],\r\n   \"Storage options\": [\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 250GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ],\r\n   \"Graphics\": [\r\n      \"Radeon™ 700M Graphics\",\r\n      \"ENTEL® Iris™ XP\"\r\n   ],\r\n   \"Display\": [\r\n      \"13.5” 3:2 2256*1504px \",\r\n      \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n      \"Available in matte and glossy covers\"\r\n   ],\r\n   \"Battery\": [\r\n      \"55Wh\",\r\n      \"61Wh\"\r\n   ],\r\n   \"Operating system\": [\r\n      \"Michealsoft Door 11 Home\",\r\n      \"Michealsoft Door 11 Pro\",\r\n      \"DEDSEC ctOS Workstation\",\r\n      \"None (bring your own) - Check out our recommended Linux distros\"\r\n   ]\r\n}'),
(7, 'DEDSEC Laptop 13 (DMA Ryzen™ 7040 Series) 3', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/image1.png', 0, 'Extremely modular design with upgradable components\r\nComes with DMA Ryzen™ 7040 Series and 13th Gen ENTEL®\r\nOut-of-box compatibility with most Linux distros', '{\r\n   \"Processor options\": [\r\n      \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\",\r\n      \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\",\r\n      \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ],\r\n   \"Memory options\": [\r\n      \"DDR5-5600 - 8GB (1 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (2 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (1 x 16GB)\",\r\n      \"DDR5-5600 - 32GB (1 x 32GB)\",\r\n      \"DDR5-5600 - 32GB (2 x 16GB)\",\r\n      \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ],\r\n   \"Storage options\": [\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 250GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ],\r\n   \"Graphics\": [\r\n      \"Radeon™ 700M Graphics\",\r\n      \"ENTEL® Iris™ XP\"\r\n   ],\r\n   \"Display\": [\r\n      \"13.5” 3:2 2256*1504px \",\r\n      \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n      \"Available in matte and glossy covers\"\r\n   ],\r\n   \"Battery\": [\r\n      \"55Wh\",\r\n      \"61Wh\"\r\n   ],\r\n   \"Operating system\": [\r\n      \"Michealsoft Door 11 Home\",\r\n      \"Michealsoft Door 11 Pro\",\r\n      \"DEDSEC ctOS Workstation\",\r\n      \"None (bring your own) - Check out our recommended Linux distros\"\r\n   ]\r\n}'),
(8, 'DEDSEC Laptop 13 (ENTEL® Core™ 13th Gen) 3', '<div class=\"col-md-10 col-12\">\r\n                        <!-- Truly personal computing -->\r\n                        <div class=\"row \">\r\n                            <div class=\"col-md-8 col-12 text-end\">\r\n                                <img src=\"../images/product-details_overview-image-1.png\" alt=\"overview-image-1\" class=\"img-fluid pe-md-5\">\r\n                            </div>\r\n                            <div class=\"col-md-4 col-12 text-center align-self-center\" >\r\n                                <h5 class=\"fw-bolder\">Truly personal computing</h5>\r\n                                <p>The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.</p>\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Expansion Cards -->\r\n                        <div class=\"row\">\r\n                            <div class=\"col-md-4 col-12 text-end align-self-center order-md-0 order-1\">\r\n                                <h5 class=\"fw-bolder\">Expansion Cards</h5>\r\n                                <p>External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.</p>\r\n                            </div>\r\n                            <div class=\"col-md-8 col-12 text-end order-md-1 order-0\">\r\n                                <img src=\"../images/product-details_overview-image-2.png\" alt=\"overview-image-2\" class=\"img-fluid ps-md-5\">\r\n                            </div>\r\n                        </div>\r\n                        <br>\r\n                        <br>\r\n                        <!-- Keyboard -->\r\n                        <div class=\"row justify-content-center\">\r\n                            <img src=\"../images/product-details_overview-image-3.png\" alt=\"overview-image-3\" class=\"img-fluid\">\r\n                            \r\n                            <h5 class=\"fw-bolder pt-3\">Keyboard</h5>\r\n                            <p>The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!</p>\r\n                        </div>\r\n                    </div>\r\n\r\n                </div>', 2499.00, '/images/products/image1.png', 0, 'Extremely modular design with upgradable components\r\nComes with DMA Ryzen™ 7040 Series and 13th Gen ENTEL®\r\nOut-of-box compatibility with most Linux distros', '{\r\n   \"Processor options\": [\r\n      \"DMA Ryzen™ 7 7840U (up to 5.1GHz, 8 cores)\",\r\n      \"ENTEL® Core™ i7-1360P (up to 5.0GHz, 4+8 cores)\",\r\n      \"ENTEL® Core™ i7-1370P (up to 5.2GHz, 6+8 cores)\"\r\n   ],\r\n   \"Memory options\": [\r\n      \"DDR5-5600 - 8GB (1 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (2 x 8GB)\",\r\n      \"DDR5-5600 - 16GB (1 x 16GB)\",\r\n      \"DDR5-5600 - 32GB (1 x 32GB)\",\r\n      \"DDR5-5600 - 32GB (2 x 16GB)\",\r\n      \"DDR5-5600 - 64GB (2 x 32GB)\"\r\n   ],\r\n   \"Storage options\": [\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 250GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 500GB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN770 NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 1TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 2TB\",\r\n      \"WW_BLACK™ SN850X NVMe™- M.2 2280 - 4TB\"\r\n   ],\r\n   \"Graphics\": [\r\n      \"Radeon™ 700M Graphics\",\r\n      \"ENTEL® Iris™ XP\"\r\n   ],\r\n   \"Display\": [\r\n      \"13.5” 3:2 2256*1504px \",\r\n      \"100% sRGB coverage, 1500:1 contrast, >400 nits brightness\",\r\n      \"Available in matte and glossy covers\"\r\n   ],\r\n   \"Battery\": [\r\n      \"55Wh\",\r\n      \"61Wh\"\r\n   ],\r\n   \"Operating system\": [\r\n      \"Michealsoft Door 11 Home\",\r\n      \"Michealsoft Door 11 Pro\",\r\n      \"DEDSEC ctOS Workstation\",\r\n      \"None (bring your own) - Check out our recommended Linux distros\"\r\n   ]\r\n}');

--
-- Triggers `product`
--
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
		`cart_item_loop` :	LOOP
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

CREATE TABLE `product_category` (
  `product_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_comment`
--

CREATE TABLE `product_comment` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_rating`
--

CREATE TABLE `product_rating` (
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `rating` decimal(3,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `promotion`
--

CREATE TABLE `promotion` (
  `code` varchar(20) NOT NULL,
  `discount` decimal(5,2) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `status` enum('INACTIVE','ACTIVE','EXPIRE') DEFAULT 'INACTIVE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','USER') NOT NULL DEFAULT 'USER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `role`) VALUES
(2, 'client2@gmail.com', '$2y$10$XMlQEODZ9HsEm/DCjEGzdeK6axApEAIguTIF899I0ou6TW/50h2GW', 'ADMIN');

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`id`, `name`, `image_url`, `birth_date`, `phone`, `address`) VALUES
(2, 'Kiet Client 2', 'https://images.unsplash.com/photo-1683129384918-684af5f77d6d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHVtYmF8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60', NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blog`
--
ALTER TABLE `blog`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`author_id`);

--
-- Indexes for table `blog_comment`
--
ALTER TABLE `blog_comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `blog_id` (`blog_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cart_item`
--
ALTER TABLE `cart_item`
  ADD KEY `cart_id` (`cart_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `cart_promotion`
--
ALTER TABLE `cart_promotion`
  ADD PRIMARY KEY (`cart_id`,`promotion_code`),
  ADD KEY `promotion_code` (`promotion_code`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_name_unique` (`name`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_name_unique` (`name`);

--
-- Indexes for table `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`product_id`,`category_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `product_comment`
--
ALTER TABLE `product_comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `product_rating`
--
ALTER TABLE `product_rating`
  ADD PRIMARY KEY (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `promotion`
--
ALTER TABLE `promotion`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_email_unique` (`email`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blog`
--
ALTER TABLE `blog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `blog_comment`
--
ALTER TABLE `blog_comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `product_comment`
--
ALTER TABLE `product_comment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blog`
--
ALTER TABLE `blog`
  ADD CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `user_info` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_info`
--
ALTER TABLE `user_info`
  ADD CONSTRAINT `user_info_ibfk_1` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `update_promotion_status` ON SCHEDULE EVERY 1 DAY STARTS '2023-08-05 09:37:45' ON COMPLETION NOT PRESERVE ENABLE DO CALL set_promotion_status ()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
