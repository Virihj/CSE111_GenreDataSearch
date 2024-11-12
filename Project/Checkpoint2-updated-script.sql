DROP TABLE IF EXISTS ItemPlatform;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS MediaType;
DROP TABLE IF EXISTS Platform;
DROP TABLE IF EXISTS MediaTypeGenre;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS AuthorItem;
DROP TABLE IF EXISTS AgeRating;
DROP TABLE IF EXISTS ItemAgeRating;

-- 1. Create MediaType Table
CREATE TABLE MediaType (
    MediaTypeID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeName TEXT NOT NULL
);

-- 2. Create Genre Table
CREATE TABLE Genre (
    GenreID INTEGER PRIMARY KEY AUTOINCREMENT,
    GenreName TEXT NOT NULL,
    MediaTypeID INTEGER,
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID)
);

-- 3. Create Item Table
CREATE TABLE Item (
    ItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemName TEXT NOT NULL,
    ReleaseYear INTEGER,
    GenreID INTEGER,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

-- 4. Create Platform Table
CREATE TABLE Platform (
    PlatformID INTEGER PRIMARY KEY AUTOINCREMENT,
    PlatformName TEXT NOT NULL
);

-- 5. Create AgeRating Table
CREATE TABLE AgeRating (
    AgeRatingID INTEGER PRIMARY KEY AUTOINCREMENT,
    AgeRatingName TEXT NOT NULL
);

-- 6. Create MediaTypeGenre Table (Junction Table for MediaType and Genre)
CREATE TABLE MediaTypeGenre (
    MediaTypeGenreID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeID INTEGER NOT NULL,
    GenreID INTEGER NOT NULL,
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    UNIQUE (MediaTypeID, GenreID) -- Ensure each MediaType-Genre combination is unique
);

-- 7. Create ItemPlatform Table (Junction Table for Item and Platform)
CREATE TABLE ItemPlatform (
    ItemPlatformID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemID INTEGER,
    PlatformID INTEGER,
    UNIQUE (ItemID, PlatformID),  -- Prevents duplicates
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID)
);

-- 8. Create ItemAgeRating Table (Junction Table for Item and AgeRating)
CREATE TABLE ItemAgeRating (
    ItemAgeRatingID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemID INTEGER NOT NULL,
    AgeRatingID INTEGER NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (AgeRatingID) REFERENCES AgeRating(AgeRatingID),
    UNIQUE (ItemID, AgeRatingID) -- Prevent duplicate entries for the same item-age rating pair
);

-- Insert data into MediaType Table
INSERT INTO MediaType (MediaTypeName)
VALUES 
    ('Games'),
    ('Books'),
    ('Music'),
    ('Movies/Shows'),
    ('Comics'),
    ('Art'),
    ('Podcasts');

-- Insert data into Genre Table
INSERT INTO Genre (GenreName, MediaTypeID)
VALUES 
    ('FPS', 1),          -- Games
    ('RPG', 1),          -- Games
    ('Fantasy', 2),      -- Books
    ('Sci-Fi', 2),       -- Books
    ('Rock', 3),         -- Music
    ('Pop', 3);          -- Music

-- Insert data into Item Table
INSERT INTO Item (ItemName, ReleaseYear, GenreID)
VALUES 
    ('God of War', 2018, 2),     -- RPG, Games
    ('Dune', 1965, 4),           -- Sci-Fi, Books
    ('Crazy in Love', 2003, 6);  -- Pop, Music

-- Insert data into Platform Table
INSERT INTO Platform (PlatformName)
VALUES 
    ('PlayStation'),
    ('Steam'),
    ('Hardcover'),
    ('Spotify');

-- Insert data into AgeRating Table
INSERT INTO AgeRating (AgeRatingName)
VALUES 
    ('E for Everyone'),
    ('M for Mature'),
    ('PG-13'),
    ('R');

-- Insert data into ItemPlatform Table
INSERT INTO ItemPlatform (ItemID, PlatformID)
VALUES 
    (1, 1),  -- God of War on PlayStation
    (1, 2),  -- God of War on Steam
    (2, 3),  -- Dune as Hardcover
    (3, 4);  -- Crazy in Love on Spotify

-- Insert data into MediaTypeGenre Table
INSERT INTO MediaTypeGenre (MediaTypeID, GenreID)
VALUES 
    (1, 1),  -- Games linked with FPS genre
    (1, 2),  -- Games linked with RPG genre
    (2, 3),  -- Books linked with Fantasy genre
    (2, 4),  -- Books linked with Sci-Fi genre
    (3, 5),  -- Music linked with Rock genre
    (3, 6);  -- Music linked with Pop genre

-- Insert data into ItemAgeRating Table to link items to their age ratings
INSERT INTO ItemAgeRating (ItemID, AgeRatingID)
VALUES 
    (1, 2),  -- God of War has M for Mature rating
    (2, 3),  -- Dune has PG-13 rating
    (3, 1);  -- Crazy in Love has E for Everyone rating
