package com.dashboard.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "fees")
public class FeeRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "student_id")
    private Long studentId;
    
    @Column(name = "student_name")
    private String studentName;
    
    @Column(name = "total_fee")
    private BigDecimal totalFee;
    
    @Column(name = "paid_amount")
    private BigDecimal paidAmount;
    
    @Column(name = "pending_amount")
    private BigDecimal pendingAmount;
    
    @Column(name = "payment_status")
    private String paymentStatus;
    
    @Column(name = "username")
    private String username;
    
    @Column(name = "password")
    private String password;

    // Getters and Setters
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public BigDecimal getTotalFee() { return totalFee; }
    public void setTotalFee(BigDecimal totalFee) { this.totalFee = totalFee; }
    
    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }
    
    public BigDecimal getPendingAmount() { return pendingAmount; }
    public void setPendingAmount(BigDecimal pendingAmount) { this.pendingAmount = pendingAmount; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
