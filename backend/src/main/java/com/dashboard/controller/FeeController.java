package com.dashboard.controller;

import com.dashboard.model.FeeRecord;
import com.dashboard.repository.FeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fees")
public class FeeController {

    @Autowired
    private FeeRepository feeRepository;

    @GetMapping
    public List<FeeRecord> getAllFees() {
        return feeRepository.findAll();
    }

    @PostMapping
    public FeeRecord createFeeRecord(@RequestBody FeeRecord feeRecord) {
        return feeRepository.save(feeRecord);
    }

    @PutMapping("/{id}")
    public FeeRecord updateFeeRecord(@PathVariable Long id, @RequestBody FeeRecord feeDetails) {
        FeeRecord fee = feeRepository.findById(id).orElseThrow();
        fee.setStudentName(feeDetails.getStudentName());
        fee.setTotalFee(feeDetails.getTotalFee());
        fee.setPaidAmount(feeDetails.getPaidAmount());
        fee.setPendingAmount(feeDetails.getPendingAmount());
        fee.setPaymentStatus(feeDetails.getPaymentStatus());
        fee.setUsername(feeDetails.getUsername());
        fee.setPassword(feeDetails.getPassword());
        return feeRepository.save(fee);
    }

    @DeleteMapping("/{id}")
    public void deleteFeeRecord(@PathVariable Long id) {
        feeRepository.deleteById(id);
    }
}
