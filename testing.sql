-- =========================================
-- TESTING : VIEW TABLE DATA
-- =========================================

SELECT * FROM customers;

SELECT * FROM accounts;

SELECT * FROM account_transactions;



-- =========================================
-- TESTING : BASIC QUERIES
-- =========================================

SELECT *
FROM accounts
WHERE status = 'Active';


SELECT
    c.full_name,
    a.account_number,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id;


SELECT
    ROUND(AVG(balance), 2) AS average_balance
FROM accounts;



-- =========================================
-- TESTING : DEPOSIT FUNCTION
-- =========================================

SELECT deposit_money(1, 5000);


SELECT
    account_id,
    balance
FROM accounts
WHERE account_id = 1;



-- =========================================
-- TESTING : WITHDRAW FUNCTION
-- =========================================

SELECT withdraw_money(2, 3000);


SELECT
    account_id,
    balance
FROM accounts
WHERE account_id = 2;



-- =========================================
-- TESTING : TRANSFER FUNCTION
-- =========================================

SELECT transfer_money(1, 3, 4000);


SELECT
    account_id,
    balance
FROM accounts
WHERE account_id IN (1, 3);



-- =========================================
-- TESTING : TRIGGER - NEGATIVE BALANCE
-- =========================================

UPDATE accounts
SET balance = -1000
WHERE account_id = 1;



-- =========================================
-- TESTING : TRIGGER - ACCOUNT DELETION
-- =========================================

DELETE FROM accounts
WHERE account_id = 1;



-- =========================================
-- TESTING : TRIGGER - STATUS CHANGE
-- =========================================

UPDATE accounts
SET status = 'Blocked'
WHERE account_id = 2;


SELECT *
FROM account_transactions
WHERE account_transaction_type = 'Status Change';



-- =========================================
-- TESTING : VIEWS
-- =========================================

SELECT * FROM active_account_view;

SELECT * FROM customer_account_summary_view;

SELECT * FROM high_value_transactions_view;

SELECT * FROM blocked_accounts_view;

SELECT *
FROM recent_transaction_view
ORDER BY account_transaction_time DESC;



-- =========================================
-- TESTING : CURSOR FUNCTIONS
-- =========================================

SELECT high_balance_accounts(50000);

SELECT show_customer_accounts(1);

SELECT daily_transaction_report(1);