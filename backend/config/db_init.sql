-- CLASS: USER
CREATE TABLE `USER` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`email` VARCHAR ( 255 ) NOT NULL,
	`password` VARCHAR ( 255 ) NOT NULL,
	`role` ENUM ( 'ADMIN', 'USER' ) DEFAULT 'USER' NOT NULL,
	CONSTRAINT user_email_unique UNIQUE ( email ) 
);
-- USER-1-----1-USER_INFO
CREATE TABLE `USER_INFO` (
	`id` INT PRIMARY KEY,
	`name` VARCHAR ( 255 ) NOT NULL,
	`image_url` VARCHAR ( 255 ),
	`birth_date` DATE,
	`phone` VARCHAR ( 20 ),
    `address` VARCHAR ( 255 ),
	FOREIGN KEY ( id ) REFERENCES USER ( id ) ON DELETE CASCADE 
);
-- CLASS: BLOG
CREATE TABLE `BLOG` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`author_id` INT,
	`title` VARCHAR ( 255 ) NOT NULL,
	`content` TEXT NOT NULL,
	`image_url` VARCHAR ( 255 ),
	`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY ( user_id ) REFERENCES USER_INFO ( id ) ON DELETE SET NULL
);
-- BLOG-1-----n-BLOG_COMMENT
CREATE TABLE `BLOG_COMMENT` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`blog_id` INT NOT NULL,
	`user_id` INT,
	`content` TEXT NOT NULL,
	`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY ( blog_id ) REFERENCES BLOG ( id ) ON DELETE CASCADE,
	FOREIGN KEY ( user_id ) REFERENCES USER_INFO ( id ) ON DELETE SET NULL
);
-- CLASS: PRODUCT
CREATE TABLE `PRODUCT` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR ( 255 ) NOT NULL,
	`description` TEXT NOT NULL,
	`price` DECIMAL ( 10, 2 ) NOT NULL DEFAULT 0,
	`image_url` VARCHAR ( 255 ) NOT NULL,
	`quantity` INT NOT NULL DEFAULT 0,
	CONSTRAINT product_name_unique UNIQUE ( NAME ) 
);
-- PRODUCT-1-----n-PRODUCT_RATE
CREATE TABLE `PRODUCT_RATING` (
	`user_id` INT NOT NULL,
	`product_id` INT NOT NULL,
	`rating` DECIMAL ( 3, 1 ) NOT NULL CHECK ( rating >= 0 AND rating <= 5 AND rating % 0.5 = 0 ),
    PRIMARY KEY ( user_id, product_id ),
	FOREIGN KEY ( product_id ) REFERENCES PRODUCT ( id ) ON DELETE CASCADE,
	FOREIGN KEY ( user_id ) REFERENCES USER ( id ) ON DELETE CASCADE
);
-- PRODUCT-1-----n-PRODUCT_COMMENT
CREATE TABLE `PRODUCT_COMMENT` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`product_id` INT NOT NULL,
	`user_id` INT,
	`content` TEXT NOT NULL,
	`created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY ( product_id ) REFERENCES PRODUCT ( id ) ON DELETE CASCADE,
	FOREIGN KEY ( user_id ) REFERENCES USER ( id ) ON DELETE SET NULL
);
-- CLASS: CATEGORY
CREATE TABLE `CATEGORY` ( 
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR ( 255 ) NOT NULL,
);
-- PRODUCT-n-----n-CATEGORY
CREATE TABLE `PRODUCT_CATEGORY` (
	`product_id` INT NOT NULL,
	`category_id` INT NOT NULL,
	PRIMARY KEY ( product_id, category_id ),
	FOREIGN KEY ( product_id ) REFERENCES PRODUCT ( id ) ON DELETE CASCADE,
	FOREIGN KEY ( category_id ) REFERENCES CATEGORY ( id ) ON DELETE CASCADE 
);

/////////////////////////////////////////////////////////////////////////////////////////

-- CLASS: CART && CART-1-----1-USER
CREATE TABLE `CART` ( 
    `id` INT PRIMARY KEY AUTO_INCREMENT, 
    `user_id` INT NOT NULL, 
    `total` DECIMAL ( 10, 2 ) NOT NULL DEFAULT 0,
	`status` ENUM ( 'BUYING', 'ORDERED', 'SHIPPING', 'DELIVERED', 'REJECTED' ) DEFAULT 'BUYING' NOT NULL,
	`ship_address` VARCHAR ( 255 ),
    `note` TEXT,
	`ordered_at` TIMESTAMP DEFAULT NULL,
	`shipped_at` TIMESTAMP DEFAULT NULL,
    FOREIGN KEY ( user_id ) REFERENCES USER ( id ) ON DELETE CASCADE 
);
-- CART-1-----n-CART_ITEM && CART_ITEM-1-----1-PRODUCT
CREATE TABLE `CART_ITEM` (
	`cart_id` INT NOT NULL,
	`product_id` INT NOT NULL,
	`quantity` INT NOT NULL DEFAULT 0,
	`total_price` DECIMAL ( 10, 2 ) DEFAULT 0 NOT NULL,
	FOREIGN KEY ( cart_id ) REFERENCES CART ( id ) ON DELETE CASCADE,
	FOREIGN KEY ( product_id ) REFERENCES PRODUCT ( id ) ON DELETE CASCADE 
);
-- CLASS: PROMOTION
CREATE TABLE `PROMOTION` (
	`code` VARCHAR ( 20 ) PRIMARY KEY,
	`discount` DECIMAL ( 5, 2 ) NOT NULL CHECK ( discount < 100 AND discount > 0 ),
	`start_date` DATE NOT NULL,
	`end_date` DATE NOT NULL,
	`status` ENUM ( 'INACTIVE', 'ACTIVE', 'EXPIRE' ) DEFAULT 'INACTIVE',
	CONSTRAINT promotion_date_check CHECK ( start_date < end_date ) 
);
-- CART-n-----n-PROMOTION
CREATE TABLE `CART_PROMOTION` (
	`cart_id` INT NOT NULL,
	`promotion_code` VARCHAR ( 20 ) NOT NULL,
	PRIMARY KEY ( cart_id, promotion_code ),
	FOREIGN KEY ( cart_id ) REFERENCES CART ( id ) ON DELETE CASCADE,
	FOREIGN KEY ( promotion_code ) REFERENCES PROMOTION ( CODE ) ON DELETE CASCADE 
);

------------------------------------------- 
-------------------EVENT--------------------
------------------------------------------- 
-- check promotion status at 00:00:00 everyday
SET GLOBAL event_scheduler = ON;
CREATE EVENT IF NOT EXISTS update_promotion_status ON SCHEDULE EVERY 1 DAY DO
	CALL set_promotion_status ();

---------------------------------------------- 
------------------- FUNCTION -----------------
---------------------------------------------- 
-- set promotion on demand 
    DELIMITER /
    / CREATE PROCEDURE `set_promotion_status` () BEGIN
    UPDATE promotion 
	SET STATUS = CASE
		WHEN start_date > CURDATE() THEN
		'INACTIVE' 
		WHEN end_date >= CURDATE() 
		AND start_date <= CURDATE() THEN
			'ACTIVE' ELSE 'EXPIRE' 
	END;
    END /
    / DELIMITER;

    -- cart item price update
    DELIMITER /
    / CREATE PROCEDURE `change_cart_item_price` ( IN cart_id INT, IN product_id INT ) BEGIN

        DECLARE pprice DECIMAL(10, 2) unsigned DEFAULT 0;
		SET pprice = ( SELECT price FROM product WHERE id = product_id );
        
        UPDATE cart_item 
        SET total_price = pprice * quantity
        WHERE cart_id = cart_id AND product_id = product_id;

    END / / DELIMITER;

    -- cart total price update
    DELIMITER /
    / CREATE PROCEDURE `change_cart_total_price` ( IN new_cart_id INT ) BEGIN
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
    END / / DELIMITER;
---------------------------------------------- 
------------------- TRIGGER ------------------
---------------------------------------------- 

-- cart_item total price after new cart_item was created
	DELIMITER /
	/ CREATE TRIGGER cart_item_insert_trigger BEFORE INSERT ON `cart_item` FOR EACH ROW
	BEGIN
			DECLARE pprice DECIMAL(10, 2) DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = price * NEW.quantity; 
	END / / 
	DELIMITER;

-- cart_item total price after product quantity was updated
	DELIMITER /
	/ CREATE TRIGGER cart_item_update_trigger BEFORE UPDATE ON `cart_item` FOR EACH ROW
	BEGIN
			DECLARE pprice DECIMAL(10, 2) DEFAULT 0;
			SET pprice = ( SELECT price FROM product WHERE id = NEW.product_id );
			SET NEW.total_price = pprice * NEW.quantity; 
	END / / 
	DELIMITER;
    
-- cart_item and cart total price after product was updated
	DELIMITER /
	/ CREATE TRIGGER product_update_trigger AFTER UPDATE ON `product` FOR EACH ROW
	BEGIN
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
		
	END / / 
	DELIMITER;
    
-- cart total price after insert cart_item
	DELIMITER /
	/ CREATE TRIGGER cart_total_price_insert_trigger AFTER INSERT ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
	END / / 
	DELIMITER;
    
-- cart total price after update cart_item
	DELIMITER /
	/ CREATE TRIGGER cart_total_price_update_trigger AFTER UPDATE ON `cart_item` FOR EACH ROW BEGIN
		CALL change_cart_total_price ( NEW.cart_id );
		
	END / / 
	DELIMITER;
    
-- cart total price after delete cart_item
	DELIMITER /
	/ CREATE TRIGGER cart_total_price_delete_trigger AFTER DELETE ON `cart_item` FOR EACH ROW BEGIN
			CALL change_cart_total_price ( OLD.cart_id );
	END / / 
	DELIMITER;
