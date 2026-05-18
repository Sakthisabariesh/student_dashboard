-- ==============================================================================
-- STUDENT FEE MANAGEMENT SYSTEM - COMPLETE SQL DATABASE
-- ==============================================================================
-- This database schema is designed for a Student Fee Management Dashboard.
-- It includes multiple tables, views, stored procedures, and triggers to
-- provide a comprehensive SQL learning environment.
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS student_dashboard;
USE student_dashboard;

-- ------------------------------------------------------------------------------
-- 1. TABLES CREATION
-- ------------------------------------------------------------------------------

-- Departments Table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    head_of_department VARCHAR(100)
);

-- Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    enrollment_date DATE NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Courses Table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    base_fee DECIMAL(10, 2) NOT NULL
);

-- Fees Table (The main table used by the Java Application)
CREATE TABLE fees (
    fee_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    total_fee DECIMAL(10, 2) NOT NULL,
    paid_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    pending_amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Payment History Table
CREATE TABLE payment_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    fee_id INT NOT NULL,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    receipt_number VARCHAR(100) UNIQUE,
    FOREIGN KEY (fee_id) REFERENCES fees(fee_id)
);

-- ------------------------------------------------------------------------------
-- 2. INSERTING DUMMY DATA
-- ------------------------------------------------------------------------------

INSERT INTO departments (department_name, head_of_department) VALUES
('Computer Science', 'Dr. Alan Turing'),
('Electrical Engineering', 'Dr. Nikola Tesla'),
('Mechanical Engineering', 'Dr. Henry Ford');

INSERT INTO students (first_name, last_name, email, phone_number, enrollment_date, department_id) VALUES
('Alice', 'Smith', 'alice.smith@example.com', '555-0101', '2023-09-01', 1),
('Bob', 'Johnson', 'bob.johnson@example.com', '555-0102', '2023-09-01', 2),
('Charlie', 'Brown', 'charlie.brown@example.com', '555-0103', '2023-09-01', 3),
('Diana', 'Prince', 'diana.prince@example.com', '555-0104', '2024-01-15', 1),
('Evan', 'Wright', 'evan.wright@example.com', '555-0105', '2024-01-15', 2);

INSERT INTO courses (course_name, credits, base_fee) VALUES
('Introduction to Programming', 4, 1500.00),
('Data Structures', 4, 1500.00),
('Circuit Analysis', 3, 1200.00),
('Thermodynamics', 3, 1200.00);

INSERT INTO fees (student_id, student_name, total_fee, paid_amount, pending_amount, payment_status, username, password) VALUES
(1, 'Alice Smith', 5000.00, 5000.00, 0.00, 'PAID', 'alice123', 'pass123'),
(2, 'Bob Johnson', 5000.00, 2500.00, 2500.00, 'PENDING', 'bob456', 'pass456'),
(3, 'Charlie Brown', 5000.00, 0.00, 5000.00, 'UNPAID', 'charlie789', 'pass789'),
(4, 'Diana Prince', 6000.00, 6000.00, 0.00, 'PAID', 'diana101', 'pass101'),
(5, 'Evan Wright', 4500.00, 1000.00, 3500.00, 'PENDING', 'evan202', 'pass202');

INSERT INTO payment_transactions (fee_id, amount_paid, payment_method, receipt_number) VALUES
(1, 5000.00, 'Credit Card', 'REC-001'),
(2, 2500.00, 'Bank Transfer', 'REC-002'),
(4, 6000.00, 'Debit Card', 'REC-003'),
(5, 1000.00, 'Cash', 'REC-004');

-- ------------------------------------------------------------------------------
-- 3. VIEWS (For easy querying and reporting)
-- ------------------------------------------------------------------------------

CREATE VIEW vw_student_fee_summary AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    d.department_name,
    f.total_fee,
    f.paid_amount,
    f.pending_amount,
    f.payment_status
FROM 
    students s
JOIN 
    fees f ON s.student_id = f.student_id
JOIN 
    departments d ON s.department_id = d.department_id;

CREATE VIEW vw_defaulters_list AS
SELECT 
    student_name,
    pending_amount,
    email,
    phone_number
FROM 
    vw_student_fee_summary v
JOIN 
    students s ON v.student_id = s.student_id
WHERE 
    v.payment_status IN ('UNPAID', 'PENDING') AND v.pending_amount > 0;

-- ------------------------------------------------------------------------------
-- 4. STORED PROCEDURES (For complex operations)
-- ------------------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE ProcessPayment(
    IN p_fee_id INT,
    IN p_amount DECIMAL(10,2),
    IN p_method VARCHAR(50)
)
BEGIN
    DECLARE v_current_pending DECIMAL(10,2);
    
    -- Get current pending amount
    SELECT pending_amount INTO v_current_pending FROM fees WHERE fee_id = p_fee_id;
    
    IF p_amount <= v_current_pending THEN
        -- Insert transaction record
        INSERT INTO payment_transactions (fee_id, amount_paid, payment_method, receipt_number)
        VALUES (p_fee_id, p_amount, p_method, CONCAT('REC-', UNIX_TIMESTAMP()));
        
        -- Update fees table
        UPDATE fees 
        SET paid_amount = paid_amount + p_amount,
            pending_amount = pending_amount - p_amount,
            payment_status = CASE 
                                WHEN pending_amount - p_amount = 0 THEN 'PAID'
                                ELSE 'PENDING'
                             END
        WHERE fee_id = p_fee_id;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment amount exceeds pending amount';
    END IF;
END //

DELIMITER ;

-- ------------------------------------------------------------------------------
-- 5. TRIGGERS (To enforce business rules)
-- ------------------------------------------------------------------------------

DELIMITER //

CREATE TRIGGER before_fee_insert
BEFORE INSERT ON fees
FOR EACH ROW
BEGIN
    -- Ensure pending amount is calculated correctly on insert
    SET NEW.pending_amount = NEW.total_fee - NEW.paid_amount;
    
    -- Set correct payment status based on amounts
    IF NEW.pending_amount = 0 THEN
        SET NEW.payment_status = 'PAID';
    ELSEIF NEW.paid_amount = 0 THEN
        SET NEW.payment_status = 'UNPAID';
    ELSE
        SET NEW.payment_status = 'PENDING';
    END IF;
END //

DELIMITER ;

-- ==============================================================================
-- END OF SQL SCRIPT
-- ==============================================================================
