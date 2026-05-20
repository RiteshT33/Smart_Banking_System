-- =========================================
-- VIEW : ACTIVE ACCOUNT VIEW
-- =========================================

CREATE OR REPLACE VIEW active_account_view AS

SELECT
    a.account_id,
    c.full_name,
    a.account_number,
    a.account_type,
    a.balance,
    a.status
FROM accounts a
INNER JOIN customers c
    ON a.customer_id = c.customer_id
WHERE status = 'Active';



-- =========================================
-- VIEW : CUSTOMER ACCOUNT SUMMARY VIEW
-- =========================================

CREATE OR REPLACE VIEW customer_account_summary_view AS

SELECT
    c.full_name AS customer_name,

    COUNT(a.account_id) AS total_accounts,

    COALESCE(
        SUM(a.balance),
        0
    ) AS total_balance,

    COALESCE(
        ROUND(AVG(a.balance), 2),
        0
    ) AS average_balance

FROM customers c

LEFT JOIN accounts a
    ON c.customer_id = a.customer_id

GROUP BY
    c.customer_id,
    c.full_name;



-- =========================================
-- VIEW : HIGH VALUE TRANSACTIONS VIEW
-- =========================================

CREATE OR REPLACE VIEW high_value_transactions_view AS

SELECT *
FROM account_transactions
WHERE amount > 10000;



-- =========================================
-- VIEW : BLOCKED ACCOUNTS VIEW
-- =========================================

CREATE OR REPLACE VIEW blocked_accounts_view AS

SELECT *
FROM accounts
WHERE status = 'Blocked';



-- =========================================
-- VIEW : RECENT TRANSACTION VIEW
-- =========================================

CREATE OR REPLACE VIEW recent_transaction_view AS

SELECT *
FROM account_transactions;