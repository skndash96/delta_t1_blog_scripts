-- Create database
CREATE DATABASE IF NOT EXISTS blogdb;
USE blogdb;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name TEXT NOT NULL
);

-- Create blogs table
CREATE TABLE IF NOT EXISTS blogs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name TEXT NOT NULL,
  author TEXT NOT NULL,
  categories TEXT,
  is_subscribers_only BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT FALSE
);

-- Create indexes
CREATE INDEX idx_users_name ON users(name(100));
CREATE INDEX idx_blogs_name ON blogs(name(100));
CREATE INDEX idx_blogs_author ON blogs(author(100));
