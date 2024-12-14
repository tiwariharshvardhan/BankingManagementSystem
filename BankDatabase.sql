CREATE DATABASE BankingSystem;

USE BankingSystem;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Address TEXT
);

CREATE TABLE Accounts (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    AccountType VARCHAR(50) NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL,
    InterestRate DECIMAL(5, 2) DEFAULT 3.5,
    OverdraftEnabled BOOLEAN DEFAULT FALSE,
    OverdraftLimit DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(50) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Branches (
    BranchID INT AUTO_INCREMENT PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    BranchAddress TEXT
);

CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    LoanAmount DECIMAL(12, 2) NOT NULL,
    InterestRate DECIMAL(5, 2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    RepaymentStatus VARCHAR(50) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

DROP TABLE IF EXISTS AuditLogs;

CREATE TABLE AuditLogs (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    ActionType VARCHAR(50),
    ActionDetails TEXT,
    ActionTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER ApplyInterest
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.TransactionType = 'Deposit' THEN
        UPDATE Accounts
        SET Balance = Balance + (Balance * InterestRate / 100)
        WHERE AccountID = NEW.AccountID;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER LogAccountUpdates
AFTER UPDATE ON Accounts
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogs (ActionType, ActionDetails)
    VALUES ('Account Update', CONCAT('AccountID: ', OLD.AccountID, 
                                     ', Old Balance: ', OLD.Balance, 
                                     ', New Balance: ', NEW.Balance));
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER LogLoanApproval
AFTER INSERT ON Loans
FOR EACH ROW
BEGIN
    INSERT INTO AuditLogs (ActionType, ActionDetails)
    VALUES ('Loan Approved', CONCAT('LoanID: ', NEW.LoanID, 
                                     ', CustomerID: ', NEW.CustomerID, 
                                     ', Amount: ', NEW.LoanAmount));
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AddAccount(
    IN p_CustomerID INT,
    IN p_BranchID INT,
    IN p_AccountType VARCHAR(50),
    IN p_Balance DECIMAL(10, 2)
)
BEGIN
    INSERT INTO Accounts (CustomerID, BranchID, AccountType, Balance)
    VALUES (p_CustomerID, p_BranchID, p_AccountType, p_Balance);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE EditAccount(
    IN p_AccountID INT,
    IN p_AccountType VARCHAR(50),
    IN p_Balance DECIMAL(10, 2)
)
BEGIN
    UPDATE Accounts
    SET AccountType = p_AccountType, Balance = p_Balance
    WHERE AccountID = p_AccountID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ApproveLoan(
    IN p_CustomerID INT,
    IN p_LoanAmount DECIMAL(12, 2),
    IN p_InterestRate DECIMAL(5, 2),
    IN p_StartDate DATE,
    IN p_EndDate DATE
)
BEGIN
    INSERT INTO Loans (CustomerID, LoanAmount, InterestRate, StartDate, EndDate)
    VALUES (p_CustomerID, p_LoanAmount, p_InterestRate, p_StartDate, p_EndDate);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ViewAccountSummary(
    IN p_AccountID INT
)
BEGIN
    SELECT 
        a.AccountID,
        a.CustomerID,
        a.BranchID,
        a.AccountType,
        a.Balance,
        t.TransactionID,
        t.TransactionType,
        t.Amount,
        t.TransactionDate
    FROM Accounts a
    LEFT JOIN Transactions t ON a.AccountID = t.AccountID
    WHERE a.AccountID = p_AccountID
    ORDER BY t.TransactionDate DESC;
END //
DELIMITER ;

INSERT INTO Customers (Name, Email, PhoneNumber, Address)
VALUES ('Harshvardhan Tiwari', '012tiwariharshvardhan@gmail.com', '9462175115', 'Rohinipuram, DDU Nagar, Raipur');

INSERT INTO Branches (BranchName, BranchAddress)
VALUES ('NIT Branch', 'NIT Raipur Campus, G. E. Road');

CALL AddAccount(1, 1, 'Savings', 5000.00);

CALL EditAccount(1, 'Current', 7000.00);

CALL ApproveLoan(1, 200000.00, 6.5, '2024-01-01', '2029-01-01');

CALL ViewAccountSummary(1);
