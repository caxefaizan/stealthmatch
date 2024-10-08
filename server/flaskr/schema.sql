PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS preference;
DROP TABLE IF EXISTS lifestyle;
DROP TABLE IF EXISTS parents;
DROP TABLE IF EXISTS residence;
DROP TABLE IF EXISTS sibling;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS visitors;

CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    senderId INTEGER NOT NULL,
    recipientId INTEGER NOT NULL,
    messageText TEXT NOT NULL,
    timeStamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  email TEXT NOT NULL,
  lastActivity TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS client (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    token TEXT NOT NULL,
    clientGender TEXT NOT NULL,
    clientCast TEXT NOT NULL,
    clientOccupation TEXT NOT NULL,
    clientEducation TEXT NOT NULL,
    clientAge INTEGER NOT NULL,
    clientHeight FLOAT NOT NULL,
    clientComplexion TEXT NOT NULL,
    FOREIGN KEY (token) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS preference (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    token TEXT NOT NULL,
    preferenceGender TEXT NOT NULL,
    preferenceOccupation TEXT NOT NULL,
    preferenceEducation TEXT NOT NULL,
    preferenceAge INTEGER NOT NULL,
    preferenceHeight FLOAT NOT NULL,
    preferenceComplexion TEXT NOT NULL,
    FOREIGN KEY (token) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS sibling (
    id INTEGER UNIQUE PRIMARY KEY,
    token TEXT NOT NULL,
    siblingGender TEXT NOT NULL,
    siblingOccupation TEXT NOT NULL,
    siblingSpouseCast TEXT NOT NULL,
    siblingSpouseOccupation TEXT NOT NULL,
    FOREIGN KEY (token) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS parents (
    id INTEGER UNIQUE PRIMARY KEY,
    token TEXT NOT NULL,
    fathersOccupation TEXT NOT NULL,
    mothersOccupation TEXT NOT NULL,
    mothersCast TEXT NOT NULL,
    otherRelations TEXT NOT NULL,
    FOREIGN KEY (token) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS lifestyle (
    id INTEGER UNIQUE PRIMARY KEY,
    token TEXT NOT NULL,
    smoking BOOLEAN NOT NULL,
    prayers TEXT NOT NULL,
    religiousSect TEXT NOT NULL,
    FOREIGN KEY (token) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS residence (
    id INTEGER UNIQUE PRIMARY KEY,
    token TEXT NOT NULL,
    presentAddress TEXT NOT NULL,
    permanentAddress TEXT NOT NULL,
    oldAddress TEXT NOT NULL,
    FOREIGN KEY (token) REFERENCES user(id)
);

CREATE TABLE IF NOT EXISTS visitors (
    id INTEGER PRIMARY KEY,
    count INTEGER NOT NULL
);
INSERT INTO visitors (count) VALUES (0)