-- =========================================
-- DROP EXISTING TABLES
-- =========================================

DROP TABLE account_transactions CASCADE;
DROP TABLE accounts CASCADE;
DROP TABLE customers CASCADE;


-- =========================================
-- CUSTOMERS TABLE
-- =========================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =========================================
-- ACCOUNTS TABLE
-- =========================================

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,

    customer_id INT NOT NULL,

    account_number VARCHAR(20) NOT NULL UNIQUE,

    account_type VARCHAR(20)
        CONSTRAINT valid_account_type
        CHECK (
            account_type IN (
                'Saving',
                'Current',
                'Salary',
                'Fixed Deposits',
                'Recurring Deposits'
            )
        ) NOT NULL,

    balance NUMERIC(12,2)
        CONSTRAINT valid_balance
        CHECK (balance >= 0) NOT NULL,

    status VARCHAR(20)
        CONSTRAINT valid_account_status
        CHECK (
            status IN (
                'Active',
                'Inactive',
                'Blocked'
            )
        ) DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- =========================================
-- ACCOUNT TRANSACTIONS TABLE
-- =========================================

CREATE TABLE account_transactions (
    account_transaction_id SERIAL PRIMARY KEY,

    account_id INT NOT NULL,

    account_transaction_type VARCHAR(20)
        CONSTRAINT valid_transaction_type
        CHECK (
            account_transaction_type IN (
                'Deposits',
                'Withdrawals',
                'Transfers',
                'Status Change'
            )
        ) NOT NULL,

    amount NUMERIC(12,2) NOT NULL,

    account_transaction_time TIMESTAMP NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    description VARCHAR(255),

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);