DROP DATABASE IF EXISTS fraud_case;
CREATE DATABASE fraud_case;
USE fraud_case;

DROP TABLE IF EXISTS fraud_raw;

CREATE TABLE fraud_raw (
    row_id INT,
    trans_date_trans_time VARCHAR(50),
    cc_num VARCHAR(30),
    merchant VARCHAR(255),
    category VARCHAR(100),
    amt DECIMAL(10,2),
    first VARCHAR(100),
    last VARCHAR(100),
    gender CHAR(1),
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    zip VARCHAR(20),
    lat DECIMAL(10,6),
    city_pop INT,
    job VARCHAR(255),
    dob VARCHAR(50),
    trans_num VARCHAR(100),
    unix_time BIGINT,
    merch_lat DECIMAL(10,6),
    merch_long DECIMAL(10,6),
    is_fraud TINYINT
);
SHOW TABLES;