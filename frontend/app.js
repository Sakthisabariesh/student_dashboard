// Mock Data for frontend since backend might not be running initially
let feesData = [
    { studentId: 1, studentName: 'Alice Smith', totalFee: 5000, paidAmount: 5000, pendingAmount: 0, paymentStatus: 'PAID' },
    { studentId: 2, studentName: 'Bob Johnson', totalFee: 5000, paidAmount: 2500, pendingAmount: 2500, paymentStatus: 'PENDING' },
    { studentId: 3, studentName: 'Charlie Brown', totalFee: 5000, paidAmount: 0, pendingAmount: 5000, paymentStatus: 'UNPAID' }
];

// In a real app, you would fetch from the Spring Boot API:
// const API_URL = 'http://localhost:8080/api/fees';
// async function fetchData() { ... }

function renderDashboard() {
    updateKPIs();
    renderTable();
}

function updateKPIs() {
    document.getElementById('total-students').innerText = feesData.length;
    
    const totalCollected = feesData.reduce((sum, item) => sum + Number(item.paidAmount), 0);
    document.getElementById('total-collected').innerText = '₹' + totalCollected.toLocaleString();
    
    const totalPending = feesData.reduce((sum, item) => sum + Number(item.pendingAmount), 0);
    document.getElementById('total-pending').innerText = '₹' + totalPending.toLocaleString();
}

function renderTable(data = feesData) {
    const tbody = document.getElementById('table-body');
    tbody.innerHTML = '';
    
    data.forEach(item => {
        let statusClass = item.paymentStatus.toLowerCase();
        
        let row = `<tr>
            <td>#${item.studentId}</td>
            <td>${item.studentName}</td>
            <td>₹${Number(item.totalFee).toLocaleString()}</td>
            <td>₹${Number(item.paidAmount).toLocaleString()}</td>
            <td>₹${Number(item.pendingAmount).toLocaleString()}</td>
            <td><span class="status ${statusClass}">${item.paymentStatus}</span></td>
            <td>
                <button class="btn-icon" onclick="editRecord(${item.studentId})" title="Edit"><i class="fa-solid fa-pen"></i></button>
                <button class="btn-icon btn-danger" onclick="deleteRecord(${item.studentId})" title="Delete"><i class="fa-solid fa-trash"></i></button>
            </td>
        </tr>`;
        tbody.innerHTML += row;
    });
}

// Search Functionality
document.getElementById('searchInput').addEventListener('input', (e) => {
    const searchTerm = e.target.value.toLowerCase();
    const filteredData = feesData.filter(item => 
        item.studentName.toLowerCase().includes(searchTerm)
    );
    renderTable(filteredData);
});

// Modal Logic
const modal = document.getElementById('addModal');
const form = document.getElementById('feeForm');

function openModal() {
    form.reset();
    document.getElementById('studentId').value = '';
    modal.style.display = 'flex';
}

function closeModal() {
    modal.style.display = 'none';
}

function editRecord(id) {
    const record = feesData.find(item => item.studentId === id);
    if (record) {
        document.getElementById('studentId').value = record.studentId;
        document.getElementById('studentName').value = record.studentName;
        document.getElementById('totalFee').value = record.totalFee;
        document.getElementById('paidAmount').value = record.paidAmount;
        document.getElementById('username').value = record.username || '';
        document.getElementById('password').value = record.password || '';
        modal.style.display = 'flex';
    }
}

function deleteRecord(id) {
    if(confirm('Are you sure you want to delete this record?')) {
        feesData = feesData.filter(item => item.studentId !== id);
        renderDashboard();
    }
}

form.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const id = document.getElementById('studentId').value;
    const name = document.getElementById('studentName').value;
    const totalFee = Number(document.getElementById('totalFee').value);
    const paidAmount = Number(document.getElementById('paidAmount').value);
    const pendingAmount = totalFee - paidAmount;
    
    let status = 'UNPAID';
    if(paidAmount >= totalFee) status = 'PAID';
    else if(paidAmount > 0) status = 'PENDING';

    const newRecord = {
        studentId: id ? parseInt(id) : Date.now(),
        studentName: name,
        totalFee: totalFee,
        paidAmount: paidAmount,
        pendingAmount: pendingAmount,
        paymentStatus: status,
        username: document.getElementById('username').value,
        password: document.getElementById('password').value
    };

    if (id) {
        // Update
        const index = feesData.findIndex(item => item.studentId === parseInt(id));
        feesData[index] = newRecord;
    } else {
        // Add
        feesData.push(newRecord);
    }
    
    closeModal();
    renderDashboard();
});

// Initial Render
renderDashboard();
