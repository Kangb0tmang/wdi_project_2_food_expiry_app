CREATE TABLE users
(
   id SERIAL4 PRIMARY KEY,
   username VARCHAR(300) NOT NULL UNIQUE,
   name VARCHAR(300) NOT NULL,
   email VARCHAR(300) NOT NULL UNIQUE,
   password_digest VARCHAR(400) NOT NULL
);

CREATE TABLE fridge_items
(
   id SERIAL4 PRIMARY KEY,
   item_name VARCHAR(200) NOT NULL,
   purchase_date DATE NOT NULL,
   expiry_date DATE NOT NULL,
   status VARCHAR(100) NOT NULL,
   img_url VARCHAR(400) NOT NULL,
   notification DATE NOT NULL
);
-- FOREIGN KEY (user_id) REFERENCES users (id) NOT NULL

CREATE TABLE freezer_items
(
   id SERIAL4 PRIMARY KEY,
   item_name VARCHAR(200) NOT NULL,
   purchase_date DATE NOT NULL,
   expiry_date DATE NOT NULL,
   status VARCHAR(100) NOT NULL,
   img_url VARCHAR(400) NOT NULL,
   notification DATE NOT NULL
);
-- FOREIGN KEY (user_id) REFERENCES users (id) NOT NULL

CREATE TABLE pantry_items
(
   id SERIAL4 PRIMARY KEY,
   item_name VARCHAR(200),
   purchase_date DATE,
   expiry_date DATE,
   status VARCHAR(100),
   img_url VARCHAR(400),
   notification DATE
);
-- FOREIGN KEY (user_id) REFERENCES users (id) NOT NULL

CREATE TABLE food_guide
(
   id SERIAL4 PRIMARY KEY,
   food_name VARCHAR(200),
   use_by_time VARCHAR(100),
   icon_url VARCHAR(400)
);
