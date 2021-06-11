create database goodfoodhunting;

\c goodfoodhunting

CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    gender TEXT,
    employment TEXT,
    image_url TEXT
);


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email TEXT,
    password_digest TEXT
);


ALTER TABLE profiles ADD COLUMN user_id INTEGER;

ALTER TABLE users ADD COLUMN first_name TEXT;
ALTER TABLE users ADD COLUMN last_name TEXT;
ALTER TABLE profiles ADD COLUMN smoker TEXT;
ALTER TABLE profiles ADD COLUMN pets TEXT;
ALTER TABLE profiles ADD COLUMN children TEXT;
ALTER TABLE profiles ADD COLUMN tea_or_coffee TEXT;



