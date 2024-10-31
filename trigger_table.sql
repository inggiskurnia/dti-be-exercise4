CREATE OR REPLACE FUNCTION update_wallet_balance()
RETURNS TRIGGER AS $$
DECLARE
    wallet_id INTEGER;
    table_name TEXT;
    column_name TEXT;
    old_amount INTEGER;
BEGIN

    -- Update wallet if goal is NULL, otherwise update goal
    IF (NEW.goal IS NULL OR OLD.goal IS NOT NULL) THEN
        wallet_id := (SELECT p.wallet_id FROM pockets p WHERE id = COALESCE(NEW.pocket, OLD.pocket));
        table_name := 'wallets';
        column_name := 'balance'; 
    ELSE
        wallet_id := (SELECT g.wallet_id FROM goals g WHERE id = COALESCE(NEW.goal, OLD.goal));
        table_name := 'goals';
        column_name := 'current_balance'; 
    END IF;

    -- Handle INSERT
    IF TG_OP = 'INSERT' THEN
        EXECUTE 'UPDATE ' || table_name || ' SET ' || column_name || ' = ' || column_name || ' + $1 WHERE id = $2'
        USING NEW.amount, wallet_id;
    -- Handle UPDATE
    ELSIF TG_OP = 'UPDATE' THEN
        old_amount := OLD.amount;
        EXECUTE 'UPDATE ' || table_name || ' SET ' || column_name || ' = ' || column_name || ' - $1 + $2 WHERE id = $3'
        USING old_amount, NEW.amount, wallet_id;
    -- Handle DELETE
    ELSIF TG_OP = 'DELETE' THEN
        EXECUTE 'UPDATE ' || table_name || ' SET ' || column_name || ' = ' || column_name || ' - $1 WHERE id = $2'
        USING OLD.amount, wallet_id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger for updating balance
CREATE OR REPLACE TRIGGER transaction_records_update_balance
AFTER INSERT OR UPDATE OR DELETE ON transaction_records
FOR EACH ROW
EXECUTE FUNCTION update_wallet_balance();
