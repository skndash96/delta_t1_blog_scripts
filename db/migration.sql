-- Create database
CREATE DATABASE IF NOT EXISTS blogdb;
USE blogdb;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

-- Create blogs table
CREATE TABLE IF NOT EXISTS blogs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  author_id INT,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- Create indexes
CREATE INDEX idx_users_name ON users(name);
CREATE INDEX idx_blogs_name ON blogs(name);
CREATE INDEX idx_blogs_author_id ON blogs(author_id);

