-- =========================================
-- VIEW ALL CUSTOMERS
-- =========================================

SELECT *
FROM customers;


-- =========================================
-- VIEW ALL ACTIVE ACCOUNTS
-- =========================================

SELECT *
FROM accounts
WHERE LOWER(status) = LOWER('Active');


-- =========================================
-- SHOW CUSTOMER NAMES WITH ACCOUNT DETAILS
-- =========================================

SELECT
    c.full_name,
    a.account_id,
    a.account_type,
    a.balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id;


-- =========================================
-- SHOW TOTAL BALANCE OF ALL ACCOUNTS
-- =========================================

SELECT
    SUM(balance) AS total_balance
FROM accounts;


-- =========================================
-- SHOW AVERAGE ACCOUNT BALANCE
-- =========================================

SELECT
    ROUND(AVG(balance), 2) AS average_balance
FROM accounts;


-- =========================================
-- FIND CUSTOMER WITH HIGHEST BALANCE
-- =========================================

SELECT
    c.full_name,
    a.balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
ORDER BY a.balance DESC
LIMIT 1;


-- =========================================
-- COUNT TOTAL ACCOUNTS BY TYPE
-- =========================================

SELECT
    account_type,
    COUNT(*) AS total_accounts
FROM accounts
GROUP BY account_type;


-- =========================================
-- SHOW ALL WITHDRAWALS
-- =========================================

SELECT *
FROM account_transactions
WHERE LOWER(account_transaction_type) = LOWER('Withdrawals');


-- =========================================
-- FIND TOTAL TRANSACTION AMOUNT PER ACCOUNT
-- =========================================

SELECT
    account_id,
    SUM(amount) AS total_transaction_amount
FROM account_transactions
GROUP BY account_id;


-- =========================================
-- SHOW ACCOUNTS WITH BALANCE
-- GREATER THAN AVERAGE BALANCE
-- =========================================

SELECT *
FROM accounts
WHERE balance > (
    SELECT ROUND(AVG(balance), 2)
    FROM accounts
);