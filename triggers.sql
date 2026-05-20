-- =========================================
-- TRIGGER : PREVENT NEGATIVE BALANCE
-- =========================================

CREATE OR REPLACE FUNCTION prevent_negative_balance()

RETURNS TRIGGER AS
$$

BEGIN

    IF NEW.balance < 0 THEN
        RAISE EXCEPTION
            'Invalid operation. Account balance cannot be negative';
    END IF;

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER prevent_negative_balance_trigger
BEFORE INSERT OR UPDATE ON accounts
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_balance();



-- =========================================
-- TRIGGER : PREVENT ACCOUNT DELETION
-- =========================================

CREATE OR REPLACE FUNCTION prevent_account_deletion()

RETURNS TRIGGER AS
$$

BEGIN

    IF EXISTS (
        SELECT 1
        FROM account_transactions
        WHERE account_id = OLD.account_id
    ) THEN

        RAISE EXCEPTION
            'Account deletion is not allowed because transaction history exists';

    END IF;

    RETURN OLD;

END;

$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER prevent_account_deletion_trigger
BEFORE DELETE ON accounts
FOR EACH ROW
EXECUTE FUNCTION prevent_account_deletion();



-- =========================================
-- TRIGGER : LOG ACCOUNT STATUS CHANGE
-- =========================================

CREATE OR REPLACE FUNCTION log_account_status_change()

RETURNS TRIGGER AS
$$

BEGIN

    IF OLD.status <> NEW.status THEN

        INSERT INTO account_transactions (
            account_id,
            account_transaction_type,
            amount,
            description
        )

        VALUES (
            NEW.account_id,
            'Status Change',
            0,
            FORMAT(
                'Account ID %s status changed from %s to %s',
                NEW.account_id,
                OLD.status,
                NEW.status
            )
        );

        RAISE NOTICE
            'Account status updated successfully';

    END IF;

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER log_account_status_change_trigger
AFTER UPDATE ON accounts
FOR EACH ROW
EXECUTE FUNCTION log_account_status_change();