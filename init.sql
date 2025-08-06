-- Uncle Wang Kopitiam Database Setup
-- Run this script to create the complete database structure

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- Create database
CREATE DATABASE IF NOT EXISTS `uncle_wang_restaurant` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `uncle_wang_restaurant`;

-- =====================================================
-- USERS TABLE (Admin & Cashier)
-- =====================================================
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','cashier') NOT NULL DEFAULT 'cashier',
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default admin user
INSERT INTO `users` (`username`, `email`, `password`, `role`, `full_name`) VALUES
('admin', 'admin@unclewang.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Administrator'),
('cashier1', 'cashier@unclewang.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'cashier', 'Cashier 1');

-- =====================================================
-- CATEGORIES TABLE
-- =====================================================
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_id` varchar(100) NOT NULL,
  `name_en` varchar(100) NOT NULL,
  `description_id` text,
  `description_en` text,
  `image` varchar(255) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert menu categories from existing data
INSERT INTO `categories` (`name_id`, `name_en`, `description_id`, `description_en`, `image`, `sort_order`) VALUES
('Sarapan', 'Breakfast', 'Hidangan sarapan tradisional untuk memulai hari', 'Traditional breakfast to start your day', 'Menu1.png', 1),
('Roti', 'Bread', 'Roti panggang tradisional dengan berbagai olesan', 'Traditional toast with various spreads', 'Menu2.png', 2),
('Alla Mee', 'Alla Mee', 'Sup mie tradisional Malaysia', 'Traditional Malaysian noodle soups', 'Menu3.png', 3),
('Nasi', 'Rice Dishes', 'Hidangan nasi tradisional Indonesia', 'Traditional Indonesian rice dishes', 'Menu4.png', 4),
('Nasi Goreng', 'Fried Rice', 'Nasi goreng tradisional Indonesia', 'Traditional Indonesian fried rice', 'Menu5.png', 5),
('Wok', 'Wok', 'Mie tumis yang dimasak dengan wajan', 'Stir-fried noodles cooked in wok', 'Menu6.png', 6),
('Bakmie', 'Bakmie', 'Mie gandum tradisional', 'Traditional wheat noodles', 'Menu7.png', 7),
('Snacks', 'Snacks', 'Camilan ringan dan kudapan tradisional', 'Light bites and traditional snacks', 'Menu8.png', 8),
('Minuman', 'Beverages', 'Minuman tradisional kopitiam', 'Traditional kopitiam drinks', 'Menu9.png', 9);

-- =====================================================
-- PRODUCTS TABLE
-- =====================================================
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `name_id` varchar(200) NOT NULL,
  `name_en` varchar(200) NOT NULL,
  `description_id` text,
  `description_en` text,
  `price` decimal(10,2) NOT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `stock_quantity` int(11) DEFAULT 0,
  `min_stock` int(11) DEFAULT 5,
  `is_available` tinyint(1) DEFAULT 1,
  `is_featured` tinyint(1) DEFAULT 0,
  `preparation_time` int(11) DEFAULT 15, -- in minutes
  `calories` int(11) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `sku` (`sku`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample products (from existing menu)
INSERT INTO `products` (`category_id`, `sku`, `name_id`, `name_en`, `description_id`, `description_en`, `price`, `stock_quantity`, `min_stock`) VALUES
-- Sarapan
(1, 'SAR001', 'Bubur Salmon', 'Salmon Porridge', 'Bubur nasi hangat dengan irisan salmon lembut', 'Warm rice porridge with tender slices of salmon', 30000.00, 50, 10),
(1, 'SAR002', 'Bakmi Ayam Jamur', 'Chicken Mushroom Noodles', 'Mie kuning dengan ayam suwir dan jamur', 'Yellow noodles with shredded chicken and mushrooms', 30000.00, 50, 10),
(1, 'SAR003', 'Paket Bubur Ayam + Kopi', 'Chicken Porridge + Coffee Package', 'Bubur ayam dengan kopi', 'Chicken porridge served with coffee', 30000.00, 30, 5),

-- Roti
(2, 'ROT001', 'Roti Panggang Srikaya', 'Kaya Toast', 'Roti panggang dengan selai kaya tradisional', 'Toast with traditional kaya jam', 25000.00, 100, 20),
(2, 'ROT002', 'Roti Panggang Butter', 'Butter Toast', 'Roti panggang dengan mentega creamy', 'Toast with creamy butter', 25000.00, 100, 20),
(2, 'ROT003', 'Roti Panggang Nutella', 'Nutella Toast', 'Roti panggang dengan olesan Nutella', 'Toast with Nutella spread', 30000.00, 80, 15),

-- Minuman
(9, 'MIN001', 'Kopi Tarik', 'Pulled Coffee', 'Kopi tarik tradisional', 'Traditional pulled coffee', 10000.00, 200, 50),
(9, 'MIN002', 'Teh Tawar Manis', 'Sweet Tea', 'Teh manis', 'Sweet tea', 5000.00, 200, 50),
(9, 'MIN003', 'Kopi Pandan', 'Pandan Coffee', 'Kopi dengan rasa pandan', 'Coffee with pandan flavor', 10000.00, 150, 30);

-- =====================================================
-- ORDERS TABLE
-- =====================================================
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_number` varchar(20) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `customer_email` varchar(100) DEFAULT NULL,
  `table_number` varchar(10) DEFAULT NULL,
  `order_type` enum('dine_in','takeaway','delivery') DEFAULT 'dine_in',
  `status` enum('pending','confirmed','preparing','ready','served','cancelled') DEFAULT 'pending',
  `payment_method` enum('cash','card','ewallet','qris') DEFAULT 'cash',
  `payment_status` enum('pending','paid','failed','refunded') DEFAULT 'pending',
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(10,2) DEFAULT 0.00,
  `discount_amount` decimal(10,2) DEFAULT 0.00,
  `total_amount` decimal(10,2) NOT NULL,
  `notes` text,
  `prepared_by` int(11) DEFAULT NULL,
  `served_by` int(11) DEFAULT NULL,
  `estimated_time` int(11) DEFAULT 20, -- in minutes
  `order_date` timestamp DEFAULT CURRENT_TIMESTAMP,
  `confirmed_at` timestamp NULL DEFAULT NULL,
  `prepared_at` timestamp NULL DEFAULT NULL,
  `served_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `prepared_by` (`prepared_by`),
  KEY `served_by` (`served_by`),
  KEY `status` (`status`),
  KEY `order_date` (`order_date`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`prepared_by`) REFERENCES `users` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`served_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ORDER ITEMS TABLE
-- =====================================================
CREATE TABLE `order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(200) NOT NULL, -- Store name at time of order
  `quantity` int(11) NOT NULL DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `notes` text,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- INVENTORY LOGS TABLE
-- =====================================================
CREATE TABLE `inventory_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `type` enum('in','out','adjustment') NOT NULL,
  `quantity` int(11) NOT NULL,
  `previous_stock` int(11) NOT NULL,
  `new_stock` int(11) NOT NULL,
  `reference_type` enum('order','purchase','adjustment','waste') DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `notes` text,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `created_by` (`created_by`),
  KEY `reference_type` (`reference_type`,`reference_id`),
  CONSTRAINT `inventory_logs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_logs_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- SETTINGS TABLE
-- =====================================================
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key_name` varchar(100) NOT NULL,
  `value` text,
  `description` text,
  `type` enum('string','number','boolean','json') DEFAULT 'string',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key_name` (`key_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default settings
INSERT INTO `settings` (`key_name`, `value`, `description`, `type`) VALUES
('restaurant_name', 'Uncle Wang Kopitiam', 'Restaurant name', 'string'),
('restaurant_phone', '+62 85148707154', 'Restaurant phone number', 'string'),
('restaurant_email', 'info@unclewang.com', 'Restaurant email', 'string'),
('restaurant_address', 'Ruko Sorrento Junction, Jl. Ir.Sukarno No.7, Curug Sangereng, Kelapa Dua, Tangerang Regency, Banten 15810', 'Restaurant address', 'string'),
('tax_rate', '10', 'Tax rate percentage', 'number'),
('default_language', 'id', 'Default language (id/en)', 'string'),
('order_timeout', '30', 'Order timeout in minutes', 'number'),
('min_order_amount', '15000', 'Minimum order amount', 'number'),
('kitchen_printer_ip', '', 'Kitchen printer IP address', 'string'),
('enable_online_payment', '1', 'Enable online payment', 'boolean'),
('payment_gateway', 'midtrans', 'Payment gateway (midtrans/xendit)', 'string');

-- =====================================================
-- NOTIFICATIONS TABLE
-- =====================================================
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('new_order','order_update','low_stock','system') NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `data` json DEFAULT NULL,
  `recipient_type` enum('admin','cashier','all') DEFAULT 'all',
  `recipient_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `priority` enum('low','normal','high','urgent') DEFAULT 'normal',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `recipient_id` (`recipient_id`),
  KEY `type` (`type`),
  KEY `is_read` (`is_read`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- SESSIONS TABLE (for session management)
-- =====================================================
CREATE TABLE `sessions` (
  `id` varchar(128) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `last_activity` (`last_activity`),
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TRIGGERS FOR AUTOMATIC STOCK MANAGEMENT
-- =====================================================

DELIMITER $$

-- Trigger to automatically update stock when order is confirmed
CREATE TRIGGER `update_stock_on_order` AFTER UPDATE ON `orders`
FOR EACH ROW
BEGIN
    IF NEW.status = 'confirmed' AND OLD.status = 'pending' THEN
        -- Update stock for each item in the order
        UPDATE products p
        INNER JOIN order_items oi ON p.id = oi.product_id
        SET p.stock_quantity = p.stock_quantity - oi.quantity
        WHERE oi.order_id = NEW.id;
        
        -- Log inventory changes
        INSERT INTO inventory_logs (product_id, type, quantity, previous_stock, new_stock, reference_type, reference_id)
        SELECT 
            oi.product_id,
            'out',
            oi.quantity,
            p.stock_quantity + oi.quantity,
            p.stock_quantity,
            'order',
            NEW.id
        FROM order_items oi
        INNER JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = NEW.id;
    END IF;
END$$

-- Trigger to check low stock and create notifications
CREATE TRIGGER `check_low_stock` AFTER UPDATE ON `products`
FOR EACH ROW
BEGIN
    IF NEW.stock_quantity <= NEW.min_stock AND OLD.stock_quantity > OLD.min_stock THEN
        INSERT INTO notifications (type, title, message, data, recipient_type, priority)
        VALUES (
            'low_stock',
            'Low Stock Alert',
            CONCAT('Product "', NEW.name_id, '" is running low. Current stock: ', NEW.stock_quantity),
            JSON_OBJECT('product_id', NEW.id, 'current_stock', NEW.stock_quantity, 'min_stock', NEW.min_stock),
            'admin',
            'high'
        );
    END IF;
END$$

DELIMITER ;

-- =====================================================
-- VIEWS FOR REPORTING
-- =====================================================

-- Daily sales view
CREATE VIEW `daily_sales` AS
SELECT 
    DATE(order_date) as sale_date,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    AVG(total_amount) as avg_order_value,
    SUM(CASE WHEN status = 'served' THEN 1 ELSE 0 END) as completed_orders,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as cancelled_orders
FROM orders 
GROUP BY DATE(order_date)
ORDER BY sale_date DESC;

-- Popular products view
CREATE VIEW `popular_products` AS
SELECT 
    p.id,
    p.name_id,
    p.name_en,
    p.price,
    COUNT(oi.id) as order_count,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.total_price) as total_revenue
FROM products p
INNER JOIN order_items oi ON p.id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.id
WHERE o.status IN ('served', 'ready')
GROUP BY p.id, p.name_id, p.name_en, p.price
ORDER BY total_quantity DESC;

-- Low stock products view
CREATE VIEW `low_stock_products` AS
SELECT 
    p.id,
    p.name_id,
    p.name_en,
    p.stock_quantity,
    p.min_stock,
    c.name_id as category_name,
    (p.min_stock - p.stock_quantity) as shortage_quantity
FROM products p
INNER JOIN categories c ON p.category_id = c.id
WHERE p.stock_quantity <= p.min_stock
AND p.is_available = 1
ORDER BY shortage_quantity DESC;

COMMIT;