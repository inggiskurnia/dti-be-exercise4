CREATE OR REPLACE FUNCTION update_current_balance()
RETURNS TRIGGER AS $$
DECLARE
    wallet_id INTEGER;
    table_name TEXT;
    old_amount INTEGER;
BEGIN

    -- Update current_balance on pockets and wallets if goal is NULL, otherwise update goals
    IF (NEW.goal IS NULL OR OLD.goal IS NOT NULL) THEN
        wallet_id := (SELECT p.wallet_id FROM pockets p WHERE id = COALESCE(NEW.pocket, OLD.pocket));
        table_name := 'wallets';

		-- Also update pockets
        IF NEW.pocket IS NOT NULL THEN
            -- Handle INSERT
            IF TG_OP = 'INSERT' THEN
                EXECUTE 'UPDATE pockets SET current_balance = current_balance + $1 WHERE id = $2'
                USING NEW.amount, NEW.pocket;
            -- Handle UPDATE
            ELSIF TG_OP = 'UPDATE' THEN
                old_amount := OLD.amount;
                EXECUTE 'UPDATE pockets SET current_balance = current_balance - $1 + $2 WHERE id = $3'
                USING old_amount, NEW.amount, NEW.pocket;
            -- Handle DELETE
            ELSIF TG_OP = 'DELETE' THEN
                EXECUTE 'UPDATE pockets SET current_balance = current_balance - $1 WHERE id = $2'
                USING OLD.amount, NEW.pocket;
            END IF;
        END IF;
    ELSE
        wallet_id := (SELECT g.wallet_id FROM goals g WHERE id = COALESCE(NEW.goal, OLD.goal));
        table_name := 'goals';
    END IF;

	-- Update wallets OR goals
    -- Handle INSERT
    IF TG_OP = 'INSERT' THEN
        EXECUTE 'UPDATE ' || table_name || ' SET current_balance = current_balance + $1 WHERE id = $2'
        USING NEW.amount, wallet_id;
    -- Handle UPDATE
    ELSIF TG_OP = 'UPDATE' THEN
        old_amount := OLD.amount;
        EXECUTE 'UPDATE ' || table_name || ' SET current_balance = current_balance - $1 + $2 WHERE id = $3'
        USING old_amount, NEW.amount, wallet_id;
    -- Handle DELETE
    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE 'UPDATE ' || table_name || ' SET current_balance = current_balance - $1 WHERE id = $2'
        USING OLD.amount, wallet_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger for updating current_balance
CREATE OR REPLACE TRIGGER transaction_records_update_balance
AFTER INSERT OR UPDATE OR DELETE ON transaction_records
FOR EACH ROW
EXECUTE FUNCTION update_current_balance();
