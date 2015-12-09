CREATE DATABASE splitscreen;

\c splitscreen

CREATE TABLE accounts (id SERIAL PRIMARY KEY, user_name VARCHAR(255), user_email VARCHAR(255), password_digest VARCHAR(255));
CREATE TABLE account_images (id SERIAL PRIMARY KEY, user_name VARCHAR(255), image_path TEXT, title varchar(50), views INT, likes INT, tags JSON);
