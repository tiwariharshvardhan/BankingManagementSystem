# **Banking Management System Using SQL**

## **Table of Contents**
1. [Project Description](#project-description)
2. [Features](#features)
3. [Database Schema](#database-schema)
4. [Getting Started](#getting-started)
5. [Usage](#usage)
6. [Enhancements and Future Scope](#enhancements-and-future-scope)
7. [Contributing](#contributing)

---

## **Project Description**

The **Banking Management System** is a SQL-based project designed to simulate core banking functionalities. It provides a backend system for managing accounts, transactions, loans, interest calculations, and more. This project uses triggers, stored procedures, and audit logging for efficient data management and security.

---

## **Features**

- **Core Banking Operations:**
  - Add, edit, or delete customer accounts.
  - Perform deposits, withdrawals, and balance checks.
  - Automate interest calculations for savings accounts.
- **Loan Management:**
  - Record loan details, including interest rates and repayment schedules.
  - Track loan repayment status.
- **Overdraft Facility:**
  - Enable overdraft for specific accounts with configurable limits.
  - Validate overdraft usage and enforce limits.
- **Audit Logs:**
  - Log key actions like account updates and loan approvals for transparency.
- **Account Summary:**
  - View detailed account information, including linked transactions.

---

## **Database Schema**

### **1. Tables**
- **Customers:** Stores customer information.
- **Accounts:** Tracks account details like type, balance, and overdraft settings.
- **Transactions:** Logs all account transactions.
- **Branches:** Stores branch information.
- **Loans:** Manages loan data, including repayment schedules.
- **AuditLogs:** Tracks all significant actions for auditing purposes.

### **2. Triggers**
- **ApplyInterest:** Automatically applies interest to savings accounts after deposits.
- **CheckOverdraft:** Validates overdraft usage and prevents violations.
- **LogAccountUpdates:** Logs changes made to accounts.
- **LogLoanApproval:** Logs when new loans are approved.

### **3. Stored Procedures**
- `AddAccount`: Adds a new account.
- `EditAccount`: Modifies account details.
- `ApproveLoan`: Approves a new loan.
- `ViewAccountSummary`: Displays an account's summary, including linked transactions.

---

## **Getting Started**

### **Prerequisites**
- A MySQL server installed on your machine.
- A SQL client (e.g., MySQL Workbench, phpMyAdmin, or any terminal-based client).

### **Setup**
1. Clone this repository or download the project files.
2. Open your SQL client and connect to your database server.
3. Create a new database for the project:
   ```sql
   CREATE DATABASE BankingSystem;
   ```
4. Switch to the newly created database:
   ```sql
   USE BankingSystem;
   ```
5. Execute the provided SQL script to set up the schema, triggers, and stored procedures.

---

## **Usage**

### **1. Adding a Customer**
To add a new customer:
```sql
INSERT INTO Customers (Name, Email, PhoneNumber, Address)
VALUES ('Tridev Maurya', 'mauryatridev@example.com', '9468751245', 'Sundar Nagar, Raipur');
```

### **2. Adding an Account**
To add new account:
```sql
CALL AddAccount(1, 101, 'Savings', 5000.00);
```

### **3. Performing Transactions**
To deposit or withdraw:
```sql
INSERT INTO Transactions (AccountID, TransactionType, Amount)
VALUES (1, 'Deposit', 1000.00);
```

### **4. Approving a Loan**
To approve a loan:
```sql
CALL ApproveLoan(1, 200000.00, 6.5, '2024-01-01', '2029-01-01');
```

### **5. Viewing Account Summary**
To view an account's summary:
```sql
CALL ViewAccountSummary(1);
```

---

## **Enhancements and Future Scope**

- **Additional Features:**
  - Integration with third-party APIs for real-time updates.
  - Implement repayment tracking for loans.

- **Data Security:**
  - Add role-based access control (RBAC).
  - Encrypt sensitive data like customer details.

- **Analytics:**
  - Generate reports on customer activity and account performance.
 
---

## **Contributing**
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch:
```bash
git checkout -b feature-name
```
3. Commit your changes and push to the branch.
4. Open a pull request.

---
