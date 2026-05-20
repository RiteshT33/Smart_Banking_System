-- =========================================
-- CURSOR : HIGH BALANCE ACCOUNTS
-- =========================================

CREATE OR REPLACE FUNCTION high_balance_accounts(
    p_amount NUMERIC(12,2)
)

RETURNS VOID AS
$$

DECLARE

    balance_rec RECORD;

BEGIN

    FOR balance_rec IN

        SELECT
            a.account_id,
            a.account_number,
            a.account_type,
            a.balance,
            a.status

        FROM accounts a

        WHERE a.balance > p_amount

    LOOP

        RAISE NOTICE
            'Account ID : %, Account Number : %, Account Type : %, Account Balance : %, Account Status : %',

            balance_rec.account_id,
            balance_rec.account_number,
            balance_rec.account_type,
            balance_rec.balance,
            balance_rec.status;

    END LOOP;

END;

$$ LANGUAGE plpgsql;



-- =========================================
-- CURSOR : SHOW CUSTOMER ACCOUNTS
-- =========================================

CREATE OR REPLACE FUNCTION show_customer_accounts(
    p_customer_id INT
)

RETURNS VOID AS
$$

DECLARE

    customer_account_rec RECORD;
    found_account BOOLEAN := FALSE;

BEGIN

    FOR customer_account_rec IN

        SELECT
            c.full_name,
            a.account_id,
            a.account_number,
            a.account_type,
            a.balance,
            a.status

        FROM accounts a

        INNER JOIN customers c
            ON a.customer_id = c.customer_id

        WHERE c.customer_id = p_customer_id

    LOOP

        found_account := TRUE;

        RAISE NOTICE
            'Customer Name : %, Account ID : %, Account Number : %, Account Type : %, Balance : %, Status : %',

            customer_account_rec.full_name,
            customer_account_rec.account_id,
            customer_account_rec.account_number,
            customer_account_rec.account_type,
            customer_account_rec.balance,
            customer_account_rec.status;

    END LOOP;


    IF NOT found_account THEN

        RAISE NOTICE
            'No accounts found for customer ID %',
            p_customer_id;

    END IF;

END;

$$ LANGUAGE plpgsql;



-- =========================================
-- CURSOR : DAILY TRANSACTION REPORT
-- =========================================

CREATE OR REPLACE FUNCTION daily_transaction_report(
    p_account_id INT
)

RETURNS VOID AS
$$

DECLARE

    account_transaction_rec RECORD;

    found_transaction BOOLEAN := FALSE;

    total_deposits NUMERIC(12,2) := 0;
    total_withdrawals NUMERIC(12,2) := 0;
    total_transfers NUMERIC(12,2) := 0;

    total_status_changes INT := 0;
    transaction_count INT := 0;

BEGIN

    FOR account_transaction_rec IN

        SELECT
            t.account_transaction_id,
            t.account_transaction_type,
            t.amount,
            t.account_transaction_time,
            t.description

        FROM account_transactions t

        WHERE t.account_id = p_account_id

        ORDER BY t.account_transaction_time DESC

    LOOP

        found_transaction := TRUE;

        RAISE NOTICE
            'Transaction ID : %, Transaction Type : %, Amount : %, Time : %, Description : %',

            account_transaction_rec.account_transaction_id,
            account_transaction_rec.account_transaction_type,
            account_transaction_rec.amount,
            account_transaction_rec.account_transaction_time,
            account_transaction_rec.description;


        IF account_transaction_rec.account_transaction_type = 'Deposits' THEN

            total_deposits := total_deposits + account_transaction_rec.amount;

        ELSIF account_transaction_rec.account_transaction_type = 'Withdrawals' THEN

            total_withdrawals := total_withdrawals + account_transaction_rec.amount;

        ELSIF account_transaction_rec.account_transaction_type = 'Transfers' THEN

            total_transfers := total_transfers + account_transaction_rec.amount;

        ELSIF account_transaction_rec.account_transaction_type = 'Status Change' THEN

            total_status_changes := total_status_changes + 1;

        END IF;


        transaction_count := transaction_count + 1;

    END LOOP;


    IF NOT found_transaction THEN

        RAISE NOTICE
            'No transaction records found for account ID %',
            p_account_id;

    ELSE

        RAISE NOTICE '---------------------------';
        RAISE NOTICE 'Transaction Summary';
        RAISE NOTICE '---------------------------';

        RAISE NOTICE
            'Total Deposits      : %',
            total_deposits;

        RAISE NOTICE
            'Total Withdrawals   : %',
            total_withdrawals;

        RAISE NOTICE
            'Total Transfers     : %',
            total_transfers;

        RAISE NOTICE
            'Total Transactions  : %',
            transaction_count;

        RAISE NOTICE
            'Total Status Changes : %',
            total_status_changes;

    END IF;

END;

$$ LANGUAGE plpgsql;