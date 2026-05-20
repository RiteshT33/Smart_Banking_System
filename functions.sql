-- =========================================
-- FUNCTION 1 : DEPOSIT MONEY
-- =========================================

CREATE OR REPLACE FUNCTION deposit_money(
    p_account_id INT,
    p_amount NUMERIC(12,2)
)

RETURNS VOID AS
$$

DECLARE

    p_existing_account_id INT;
    p_account_status VARCHAR(20);

BEGIN

    -- Validate deposit amount
    IF p_amount <= 0 THEN
        RAISE EXCEPTION
            'Deposit failed. Amount must be greater than zero';
    END IF;


    -- Fetch account details
    SELECT
        account_id,
        status
    INTO
        p_existing_account_id,
        p_account_status
    FROM accounts
    WHERE account_id = p_account_id;


    -- Validate account existence
    IF p_existing_account_id IS NULL THEN
        RAISE EXCEPTION
            'Deposit failed. Account ID % does not exist',
            p_account_id;
    END IF;


    -- Validate account status
    IF p_account_status <> 'Active' THEN
        RAISE EXCEPTION
            'Deposit failed. Account ID % is not active',
            p_account_id;
    END IF;


    -- Update account balance
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;


    -- Record transaction history
    INSERT INTO account_transactions (
        account_id,
        account_transaction_type,
        amount,
        description
    )

    VALUES (
        p_account_id,
        'Deposits',
        p_amount,
        FORMAT(
            'Deposited amount %s successfully',
            p_amount
        )
    );


    RAISE NOTICE
        'Deposit successful. Amount %s credited to account ID %',
        p_amount,
        p_account_id;

END;

$$ LANGUAGE plpgsql;



-- =========================================
-- FUNCTION 2 : WITHDRAW MONEY
-- =========================================

CREATE OR REPLACE FUNCTION withdraw_money(
    p_account_id INT,
    p_withdraw_amount NUMERIC(12,2)
)

RETURNS VOID AS
$$

DECLARE

    p_existing_account_id INT;
    p_balance NUMERIC(12,2);
    p_account_status VARCHAR(20);

BEGIN

    -- Validate withdrawal amount
    IF p_withdraw_amount <= 0 THEN
        RAISE EXCEPTION
            'Withdrawal failed. Amount must be greater than zero';
    END IF;


    -- Fetch account details
    SELECT
        account_id,
        balance,
        status
    INTO
        p_existing_account_id,
        p_balance,
        p_account_status
    FROM accounts
    WHERE account_id = p_account_id;


    -- Validate account existence
    IF p_existing_account_id IS NULL THEN
        RAISE EXCEPTION
            'Withdrawal failed. Account ID % does not exist',
            p_account_id;
    END IF;


    -- Validate account status
    IF p_account_status <> 'Active' THEN
        RAISE EXCEPTION
            'Withdrawal failed. Account ID % is not active',
            p_account_id;
    END IF;


    -- Check available balance
    IF p_withdraw_amount > p_balance THEN
        RAISE EXCEPTION
            'Withdrawal failed. Insufficient balance in account ID %',
            p_account_id;
    END IF;


    -- Update account balance
    UPDATE accounts
    SET balance = balance - p_withdraw_amount
    WHERE account_id = p_account_id;


    -- Record transaction history
    INSERT INTO account_transactions (
        account_id,
        account_transaction_type,
        amount,
        description
    )

    VALUES (
        p_account_id,
        'Withdrawals',
        p_withdraw_amount,
        FORMAT(
            'Withdrawn amount %s successfully',
            p_withdraw_amount
        )
    );


    RAISE NOTICE
        'Withdrawal successful. Amount %s debited from account ID %',
        p_withdraw_amount,
        p_account_id;

END;

$$ LANGUAGE plpgsql;



-- =========================================
-- FUNCTION 3 : TRANSFER MONEY
-- =========================================

CREATE OR REPLACE FUNCTION transfer_money(
    p_sender_account_id INT,
    p_receiver_account_id INT,
    p_amount NUMERIC(12,2)
)

RETURNS VOID AS
$$

DECLARE

    p_sender_account_found INT;
    p_receiver_account_found INT;

    p_sender_balance NUMERIC(12,2);

    p_sender_account_status VARCHAR(20);
    p_receiver_account_status VARCHAR(20);

BEGIN

    -- Validate transfer amount
    IF p_amount <= 0 THEN
        RAISE EXCEPTION
            'Transfer failed. Amount must be greater than zero';
    END IF;


    -- Prevent self transfer
    IF p_sender_account_id = p_receiver_account_id THEN
        RAISE EXCEPTION
            'Transfer failed. Sender and receiver accounts cannot be the same';
    END IF;


    -- Fetch sender account details
    SELECT
        account_id,
        balance,
        status
    INTO
        p_sender_account_found,
        p_sender_balance,
        p_sender_account_status
    FROM accounts
    WHERE account_id = p_sender_account_id;


    -- Fetch receiver account details
    SELECT
        account_id,
        status
    INTO
        p_receiver_account_found,
        p_receiver_account_status
    FROM accounts
    WHERE account_id = p_receiver_account_id;


    -- Validate sender account
    IF p_sender_account_found IS NULL THEN
        RAISE EXCEPTION
            'Transfer failed. Sender account ID % does not exist',
            p_sender_account_id;
    END IF;


    -- Validate receiver account
    IF p_receiver_account_found IS NULL THEN
        RAISE EXCEPTION
            'Transfer failed. Receiver account ID % does not exist',
            p_receiver_account_id;
    END IF;


    -- Validate sender account status
    IF p_sender_account_status <> 'Active' THEN
        RAISE EXCEPTION
            'Transfer failed. Sender account ID % is not active',
            p_sender_account_id;
    END IF;


    -- Validate receiver account status
    IF p_receiver_account_status <> 'Active' THEN
        RAISE EXCEPTION
            'Transfer failed. Receiver account ID % is not active',
            p_receiver_account_id;
    END IF;


    -- Check sender balance
    IF p_amount > p_sender_balance THEN
        RAISE EXCEPTION
            'Transfer failed. Insufficient balance in sender account ID %',
            p_sender_account_id;
    END IF;


    -- Deduct amount from sender account
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_sender_account_found;


    -- Add amount to receiver account
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_receiver_account_found;


    -- Record sender transaction
    INSERT INTO account_transactions (
        account_id,
        account_transaction_type,
        amount,
        description
    )

    VALUES (
        p_sender_account_found,
        'Transfers',
        p_amount,
        FORMAT(
            'Transferred amount %s to account ID %s',
            p_amount,
            p_receiver_account_found
        )
    );


    -- Record receiver transaction
    INSERT INTO account_transactions (
        account_id,
        account_transaction_type,
        amount,
        description
    )

    VALUES (
        p_receiver_account_found,
        'Deposits',
        p_amount,
        FORMAT(
            'Received amount %s from account ID %s',
            p_amount,
            p_sender_account_found
        )
    );


    RAISE NOTICE
        'Transfer successful. Amount %s transferred from account ID % to account ID %',
        p_amount,
        p_sender_account_found,
        p_receiver_account_found;

END;

$$ LANGUAGE plpgsql;