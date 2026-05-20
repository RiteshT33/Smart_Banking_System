-- =========================================
-- INSERT DATA INTO CUSTOMERS TABLE
-- =========================================

INSERT INTO customers (
    full_name,
    email,
    phone
)
VALUES
    ('Ritesh Sharma', 'ritesh.sharma@gmail.com', '9876543210'),
    ('Aarav Mehta', 'aarav.mehta@gmail.com', '9123456780'),
    ('Sneha Patil', 'sneha.patil@gmail.com', '9988776655'),
    ('Karan Joshi', 'karan.joshi@gmail.com', '9090909090'),
    ('Priya Verma', 'priya.verma@gmail.com', '9012345678');


-- =========================================
-- INSERT DATA INTO ACCOUNTS TABLE
-- =========================================

INSERT INTO accounts (
    customer_id,
    account_number,
    account_type,
    balance,
    status
)
VALUES
    (1, 'ACC1001', 'Saving', 25000.00, 'Active'),
    (2, 'ACC1002', 'Current', 78000.50, 'Active'),
    (3, 'ACC1003', 'Salary', 45000.75, 'Active'),
    (4, 'ACC1004', 'Fixed Deposits', 150000.00, 'Inactive'),
    (5, 'ACC1005', 'Recurring Deposits', 32000.25, 'Active');


-- =========================================
-- INSERT DATA INTO ACCOUNT_TRANSACTIONS TABLE
-- =========================================

INSERT INTO account_transactions (
    account_id,
    account_transaction_type,
    amount,
    description
)
VALUES
    (1, 'Deposits', 10000.00, 'Initial account deposit'),
    (2, 'Withdrawals', 5000.00, 'ATM cash withdrawal'),
    (3, 'Deposits', 15000.00, 'Monthly salary credited'),
    (4, 'Transfers', 25000.00, 'Transferred to another account'),
    (5, 'Withdrawals', 2000.00, 'Online shopping payment');