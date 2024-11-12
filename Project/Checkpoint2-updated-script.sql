DROP TABLE IF EXISTS ItemPlatform;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS MediaType;
DROP TABLE IF EXISTS Platform;
DROP TABLE IF EXISTS MediaTypeGenre;


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

-- 5. Create Platform Table
CREATE TABLE Platform (
    PlatformID INTEGER PRIMARY KEY AUTOINCREMENT,
    PlatformName TEXT NOT NULL
);

-- Create MediaTypeGenre Table (Junction Table for MediaType and Genre)
CREATE TABLE MediaTypeGenre (
    MediaTypeGenreID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeID INTEGER NOT NULL,
    GenreID INTEGER NOT NULL,
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    UNIQUE (MediaTypeID, GenreID) -- Ensure each MediaType-Genre combination is unique
);

-- 6. Create ItemPlatform Table (Junction Table for Item and Platform)
CREATE TABLE ItemPlatform (
    ItemPlatformID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemID INTEGER,
    PlatformID INTEGER,
    UNIQUE (ItemID, PlatformID),  -- Prevents duplicates
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID)
);

-- 7. Insert Data into MediaType Table
INSERT INTO MediaType (MediaTypeName)
VALUES 
    ('Games'),
    ('Books'),
    ('Music'),
    ('Movies/Shows'),
    ('Comics'),
    ('Art'),
    ('Podcasts');

-- 8. Insert Data into Genre Table
INSERT INTO Genre (GenreName, MediaTypeID)
VALUES 
    ('FPS', 1),          -- Games
    ('RPG', 1),          -- Games
    ('Fantasy', 2),      -- Books
    ('Sci-Fi', 2),       -- Books
    ('Rock', 3),         -- Music
    ('Pop', 3);          -- Music

-- 9. Insert Data into Item Table
INSERT INTO Item (ItemName, ReleaseYear, GenreID)
VALUES 
    ('God of War', 2018, 2),     -- RPG, Games
    ('Dune', 1965, 4),           -- Sci-Fi, Books
    ('Crazy in Love', 2003, 6);  -- Pop, Music

-- 10. Insert Data into Platform Table
INSERT INTO Platform (PlatformName)
VALUES 
    ('PlayStation'),
    ('Steam'),
    ('Hardcover'),
    ('Spotify');

-- 11. Insert Data into ItemPlatform Table
INSERT INTO ItemPlatform (ItemID, PlatformID)
VALUES 
    (1, 1),  -- God of War on PlayStation
    (1, 2),  -- God of War on Steam
    (2, 3),  -- Dune as Hardcover
    (3, 4);  -- Crazy in Love on Spotify

-- Insert Data into MediaTypeGenre Table
INSERT INTO MediaTypeGenre (MediaTypeID, GenreID)
VALUES 
    (1, 1),  -- Games linked with FPS genre
    (1, 2),  -- Games linked with RPG genre
    (2, 3),  -- Books linked with Fantasy genre
    (2, 4),  -- Books linked with Sci-Fi genre
    (3, 5),  -- Music linked with Rock genre
    (3, 6);  -- Music linked with Pop genre