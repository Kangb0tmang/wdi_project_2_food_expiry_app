CREATE TABLE users
(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(300) NOT NULL,
  email VARCHAR(300) NOT NULL UNIQUE,
  password_digest VARCHAR(400) NOT NULL
);

CREATE TABLE storage_types
(
  id SERIAL4 PRIMARY KEY,
  storage_name VARCHAR(200) NOT NULL
);

CREATE TABLE food_items
(
  id SERIAL4 PRIMARY KEY,
  item_name VARCHAR(200) NOT NULL,
  purchase_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  status VARCHAR(100) NOT NULL,
  notification DATE NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
  storage_type_id INTEGER NOT NULL,
  FOREIGN KEY (storage_type_id) REFERENCES storage_types (id) ON DELETE RESTRICT
);

CREATE TABLE food_guide
(
  id SERIAL4 PRIMARY KEY,
  food_name VARCHAR(200),
  use_by_time VARCHAR(100),
  icon_url VARCHAR(400)
);
