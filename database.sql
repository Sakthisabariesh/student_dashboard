CREATE DATABASE IF NOT EXISTS student_dashboard;
USE student_dashboard;

CREATE TABLE fees (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    total_fee DECIMAL(10, 2) NOT NULL,
    paid_amount DECIMAL(10, 2) NOT NULL,
    pending_amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

INSERT INTO fees (student_name, total_fee, paid_amount, pending_amount, payment_status, username, password) VALUES
('Alice Smith', 5000.00, 5000.00, 0.00, 'PAID', 'alice123', 'pass123'),
('Bob Johnson', 5000.00, 2500.00, 2500.00, 'PENDING', 'bob456', 'pass456'),
('Charlie Brown', 5000.00, 0.00, 5000.00, 'UNPAID', 'charlie789', 'pass789');
