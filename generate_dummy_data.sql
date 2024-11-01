TRUNCATE TABLE users, currencies, currency_rates, wallets, pockets, goals, transaction_records, notification_types, notifications RESTART IDENTITY;

-- Insert data into 'users' table
INSERT INTO users (name, email, pin, quotes) VALUES
('Alice', 'alice@example.com', 1234, 'To be or not to be'),
('Bob', 'bob@example.com', 2345, 'All is fair in love and war'),
('Charlie', 'charlie@example.com', 3456, 'Fortune favors the bold');

-- Insert data into 'currencies' table
INSERT INTO currencies (name, code, symbol) VALUES
('US Dollar', 'USD', '$'),
('Euro', 'EUR', '€'),
('Japanese Yen', 'JPY', '¥');

-- Insert data into 'currency_rates' table
INSERT INTO currency_rates (currency, rates) VALUES
(1, 100),
(2, 200),
(3, 300);

-- Insert data into 'wallets' table
INSERT INTO wallets (user_id, current_balance, currency_id) VALUES
(1, 1000, 1),
(2, 2000, 2),
(3, 3000, 3);

-- Insert data into 'pockets' table
INSERT INTO pockets (wallet_id, target_balance, current_balance, description, emoji) VALUES
(1, 100, 50, 'Pocket for savings', '🏦'),
(2, 200, 150, 'Pocket for travel', '✈️'),
(3, 300, 250, 'Pocket for gifts', '🎁');

-- Insert data into 'goals' table
INSERT INTO goals (wallet_id, name, target_balance, current_balance, description) VALUES
(1, 'Save for a car', 10000, 1000, 'Saving up for a new car'),
(2, 'Vacation Fund', 5000, 2000, 'Saving for a trip to Europe'),
(3, 'Emergency Fund', 3000, 1500, 'For unexpected expenses');

-- Insert data into 'transaction_records' table
INSERT INTO transaction_records (pocket, goal, name, amount, description) VALUES
(1, NULL, 'Deposit', 50, 'Added to savings pocket'),
(2, NULL, 'Deposit', 150, 'Added to travel pocket'),
(3, NULL, 'Deposit', 250, 'Added to gifts pocket');

-- Update data into goals table
insert into transaction_records (pocket, goal, name, amount, description) values
(1, 1, 'Deposit', 50, 'Added to Save for a car'),
(2, 2, 'Deposit', 150, 'Added to Vacation Fund'),
(3, 3, 'Deposit', 250, 'Added to Emergency FUnd');

-- Insert data into 'notification_types' table
INSERT INTO notification_types (name) VALUES
('Email'),
('SMS'),
('Push Notification');

-- Insert data into 'notifications' table
INSERT INTO notifications (user_id, notification_type, name, details, is_read) VALUES
(1, 1, 'Welcome', 'Welcome to our service!', FALSE),
(2, 2, 'Balance Update', 'Your balance has been updated.', TRUE),
(3, 3, 'Goal Achievement', 'You have achieved your goal!', FALSE);