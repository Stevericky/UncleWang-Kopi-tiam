<?php
/**
 * Database Configuration for Uncle Wang Restaurant System
 * 
 * This file contains database connection settings and utility functions
 * for connecting to MySQL database.
 */

class Database {
    // Database credentials
    private $host = 'localhost';
    private $db_name = 'uncle_wang_restaurant';
    private $username = 'root'; // Change this for production
    private $password = '';     // Change this for production
    private $charset = 'utf8mb4';
    
    // Connection instance
    private $pdo;
    private static $instance = null;
    
    // Database options
    private $options = [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES   => false,
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci"
    ];
    
    /**
     * Private constructor for singleton pattern
     */
    private function __construct() {
        $this->connect();
    }
    
    /**
     * Get database instance (Singleton pattern)
     */
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    /**
     * Create database connection
     */
    private function connect() {
        try {
            $dsn = "mysql:host={$this->host};dbname={$this->db_name};charset={$this->charset}";
            $this->pdo = new PDO($dsn, $this->username, $this->password, $this->options);
            
            // Set timezone
            $this->pdo->exec("SET time_zone = '+07:00'");
            
        } catch (PDOException $e) {
            // Log error
            error_log("Database connection failed: " . $e->getMessage());
            throw new Exception("Database connection failed. Please check your configuration.");
        }
    }
    
    /**
     * Get PDO connection
     */
    public function getConnection() {
        return $this->pdo;
    }
    
    /**
     * Execute a query and return results
     */
    public function query($sql, $params = []) {
        try {
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute($params);
            return $stmt;
        } catch (PDOException $e) {
            error_log("Query failed: " . $e->getMessage() . " | SQL: " . $sql);
            throw new Exception("Database query failed");
        }
    }
    
    /**
     * Fetch single row
     */
    public function fetchOne($sql, $params = []) {
        $stmt = $this->query($sql, $params);
        return $stmt->fetch();
    }
    
    /**
     * Fetch all rows
     */
    public function fetchAll($sql, $params = []) {
        $stmt = $this->query($sql, $params);
        return $stmt->fetchAll();
    }
    
    /**
     * Insert data and return last insert ID
     */
    public function insert($table, $data) {
        $columns = implode(',', array_keys($data));
        $placeholders = ':' . implode(', :', array_keys($data));
        
        $sql = "INSERT INTO {$table} ({$columns}) VALUES ({$placeholders})";
        $this->query($sql, $data);
        
        return $this->pdo->lastInsertId();
    }
    
    /**
     * Update data
     */
    public function update($table, $data, $where, $whereParams = []) {
        $setClause = [];
        foreach (array_keys($data) as $key) {
            $setClause[] = "{$key} = :{$key}";
        }
        $setClause = implode(', ', $setClause);
        
        $sql = "UPDATE {$table} SET {$setClause} WHERE {$where}";
        $params = array_merge($data, $whereParams);
        
        return $this->query($sql, $params);
    }
    
    /**
     * Delete data
     */
    public function delete($table, $where, $params = []) {
        $sql = "DELETE FROM {$table} WHERE {$where}";
        return $this->query($sql, $params);
    }
    
    /**
     * Begin transaction
     */
    public function beginTransaction() {
        return $this->pdo->beginTransaction();
    }
    
    /**
     * Commit transaction
     */
    public function commit() {
        return $this->pdo->commit();
    }
    
    /**
     * Rollback transaction
     */
    public function rollback() {
        return $this->pdo->rollback();
    }
    
    /**
     * Get table row count
     */
    public function count($table, $where = '1=1', $params = []) {
        $sql = "SELECT COUNT(*) as count FROM {$table} WHERE {$where}";
        $result = $this->fetchOne($sql, $params);
        return (int) $result['count'];
    }
    
    /**
     * Check if table exists
     */
    public function tableExists($tableName) {
        $sql = "SHOW TABLES LIKE :table";
        $result = $this->fetchOne($sql, ['table' => $tableName]);
        return !empty($result);
    }
    
    /**
     * Get database version info
     */
    public function getVersion() {
        $result = $this->fetchOne("SELECT VERSION() as version");
        return $result['version'];
    }
    
    /**
     * Escape string for safe SQL usage
     */
    public function escape($string) {
        return $this->pdo->quote($string);
    }
    
    /**
     * Close connection (destructor)
     */
    public function __destruct() {
        $this->pdo = null;
    }
}

/**
 * Helper function to get database instance
 */
function db() {
    return Database::getInstance();
}

/**
 * Helper function for quick database queries
 */
function dbQuery($sql, $params = []) {
    return db()->query($sql, $params);
}

function dbFetchOne($sql, $params = []) {
    return db()->fetchOne($sql, $params);
}

function dbFetchAll($sql, $params = []) {
    return db()->fetchAll($sql, $params);
}

function dbInsert($table, $data) {
    return db()->insert($table, $data);
}

function dbUpdate($table, $data, $where, $whereParams = []) {
    return db()->update($table, $data, $where, $whereParams);
}

function dbDelete($table, $where, $params = []) {
    return db()->delete($table, $where, $params);
}

?>