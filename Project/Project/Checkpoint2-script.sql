-- 1. Drop tables if they already exist to ensure clean slate
DROP TABLE IF EXISTS ItemPlatform;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS MediaType;

-- 2. Create MediaType Table
CREATE TABLE MediaType (
    MediaTypeID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeName TEXT NOT NULL
);

-- 3. Create Genre Table
CREATE TABLE Genre (
    GenreID INTEGER PRIMARY KEY AUTOINCREMENT,
    GenreName TEXT NOT NULL,
    MediaTypeID INTEGER,
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID)
);

-- 4. Create Item Table
CREATE TABLE Item (
    ItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemName TEXT NOT NULL,
    ReleaseYear INTEGER,
    GenreID INTEGER,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

-- 5. Create ItemPlatform Table
CREATE TABLE ItemPlatform (
    ItemPlatformID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemID INTEGER,
    PlatformName TEXT,
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

-- 6. Insert Data into MediaType Table
INSERT INTO MediaType (MediaTypeName)
VALUES 
    ('Games'),
    ('Books'),
    ('Music'),
    ('Movies/Shows'),
    ('Comics'),
    ('Art'),
    ('Podcasts');

-- 7. Insert Data into Genre Table (Examples)
INSERT INTO Genre (GenreName, MediaTypeID)
VALUES 
    ('FPS', 1),  -- Games
    ('RPG', 1),  -- Games
    ('Fantasy', 2),  -- Books
    ('Sci-Fi', 2),  -- Books
    ('Rock', 3),  -- Music
    ('Pop', 3);  -- Music

-- 8. Insert Data into Item Table (Examples)
INSERT INTO Item (ItemName, ReleaseYear, GenreID)
VALUES 
    ('God of War', 2018, 2),  -- RPG, Games
    ('Dune', 1965, 4),  -- Sci-Fi, Books
    ('Crazy in Love', 2003, 6);  -- Pop, Music

-- 9. Insert Data into ItemPlatform Table (Examples)
INSERT INTO ItemPlatform (ItemID, PlatformName)
VALUES 
    (1, 'PlayStation'),
    (1, 'Steam'),
    (2, 'Hardcover'),
    (3, 'Spotify');
