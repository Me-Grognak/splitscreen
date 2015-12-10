CREATE DATABASE splitscreen;

\c splitscreen

CREATE TABLE accounts (id SERIAL PRIMARY KEY, user_name VARCHAR(255), user_email VARCHAR(255), password_digest VARCHAR(255));
CREATE TABLE account_images (id SERIAL PRIMARY KEY, user_name VARCHAR(255), image_path TEXT, title varchar(50), views INT, likes INT);
CREATE TABLE image_likes (id SERIAL PRIMARY KEY, image_id INT, user_name VARCHAR(255));
CREATE TABLE image_comments (id SERIAL PRIMARY KEY, image_id INT, account_id INT, user_name VARCHAR(255), comment TEXT, pos_y INT, pos_x INT, border varchar(40), color varchar(40));
CREATE TABLE comments (id SERIAL PRIMARY KEY, account_id INT, comment TEXT, date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE profiles (id SERIAL PRIMARY KEY, account_id INT, location VARCHAR(255), pc BOOLEAN, ps4 BOOLEAN, xbo BOOLEAN, wiiu BOOLEAN, ps3 BOOLEAN, xb360 BOOLEAN, wii BOOLEAN, steam_id BIGSERIAL, psn_id VARCHAR(255), xbl_id VARCHAR(255));
