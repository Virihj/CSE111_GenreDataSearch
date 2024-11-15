DROP TABLE IF EXISTS ItemPlatform;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS MediaType;
DROP TABLE IF EXISTS Platform;
DROP TABLE IF EXISTS MediaTypeGenre;
DROP TABLE IF EXISTS AgeRating;
DROP TABLE IF EXISTS ItemAgeRating;

-- 1. Create MediaType Table
CREATE TABLE MediaType (
    MediaTypeID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeName TEXT NOT NULL
);

-- 2. Create Genre Table (Allow for a "Mix" Genre with MediaTypeID = 7)
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

-- Insert data into MediaType Table, including ID 6 for "Mix"
INSERT INTO MediaType (MediaTypeName)
VALUES 
    ('Games'),          --1
    ('Books'),          --2
    ('Music'),          --3
    ('Movies/Shows'),   --4
    ('Art'),            --5
    ('Mix');            --6

-- Insert data into Genre Table
INSERT INTO Genre (GenreName, MediaTypeID)
VALUES 
    ('FPS', 1),          -- Games
    ('RPG', 1),          -- Games
    ('Story', 1),        -- Games
    ('MMO', 1),          -- Games
    ('MOBA', 1),         -- Games
    ('Fantasy', 2),      -- Books
    ('Sci-Fi', 2),       -- Books
    ('Comic', 2),        -- Books
    ('Rock', 3),         -- Music
    ('Pop', 3),          -- Music
    ('Hip-Hop', 3),      -- Music
    ('Metal', 3),        -- Music
    ('Documentary', 4),  -- Movies/Shows
    ('Thriller', 4),     -- Movies/Shows
    ('Abstract', 5),     -- Art
    ('Realism', 5),      -- Art
    ('Surrealism', 5),   -- Art
    ('Impressionism', 5),-- Art
    ('Renaissance', 5),  -- Art
    ('Romance', 6),      -- Mix
    ('Comedy', 6),       -- Mix
    ('Action', 6);       -- Mix

-- Insert data into Item Table
INSERT INTO Item (ItemName, ReleaseYear, GenreID)
VALUES 
    ('God of War', 2018, 2),                           -- RPG, Games
    ('Dune', 1965, 7),                                 -- Sci-Fi, Books
    ('Crazy in Love', 2003, 10),                       -- Pop, Music
    ('Fancy', 2010, 11),                               -- Hip-Hop, Music
    ('Uptown Funk', 2014, 10),                         -- Pop, Music
    ('Lose You to Love Me', 2019, 10),                 -- Pop, Music
    ('Harry Potter and the Sorcerers Stone', 1997, 6), -- Fantasy, Books
    ('The Lightning Thief', 2005, 6),                  -- Fantasy, Books
    ('Super Mario Odyssey', 2017, 1),                  -- FPS, Games
    ('Sonic the Hedgehog', 1991, 1),                   -- FPS, Games
    ('Spider-Man: Homecoming', 2017, 8),               -- Comic, Books
    ('Batman: Year One', 1987, 8),                     -- Comic, Books
    ('X-Men: Days of Future Past', 1981, 8),           -- Comic, Books
    ('Justice League: Origin', 2011, 8),               -- Comic, Books
    ('Mona Lisa', 1503, 20),                           -- Renaissance, Art
    ('The Last Supper', 1498, 20),                     -- Renaissance, Art
    ('Starry Night', 1889, 20),                        -- Renaissance, Art
    ('Girl with a Pearl Earring', 1665, 20),           -- Renaissance, Art
    ('The Creation of Adam', 1512, 20);                -- Renaissance, Art

-- Insert data into Platform Table
INSERT INTO Platform (PlatformName)
VALUES 
    ('PlayStation'),
    ('Steam'),
    ('Hardcover'),
    ('Spotify'),
    ('Nintendo Switch'),
    ('Xbox'),
    ('Apple Books'),
    ('Digital'),
    ('Trade Paperback'),
    ('Museum');

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
    (3, 4),  -- Crazy in Love on Spotify
    (4, 4),  -- Fancy on Spotify
    (5, 4),  -- Uptown Funk on Spotify
    (6, 4),  -- Lose You to Love Me on Spotify
    (7, 3),  -- Harry Potter on Hardcover
    (8, 3),  -- The Lightning Thief on Hardcover
    (9, 5),  -- Super Mario Odyssey on Nintendo Switch
    (10, 5), -- Sonic the Hedgehog on Nintendo Switch
    (11, 8), -- Spider-Man: Homecoming as Digital
    (12, 9), -- Batman: Year One as Trade Paperback
    (13, 8), -- X-Men: Days of Future Past as Digital
    (14, 9), -- Justice League: Origin as Trade Paperback
    (15, 10), -- Mona Lisa in Museum
    (16, 10), -- The Last Supper in Museum
    (17, 10), -- Starry Night in Museum
    (18, 10), -- Girl with a Pearl Earring in Museum
    (19, 10); -- The Creation of Adam in Museum

-- Insert data into MediaTypeGenre Table, using MediaTypeID = 6 (Mix) for common genres
INSERT INTO MediaTypeGenre (MediaTypeID, GenreID)
VALUES 
    (1, 1),  -- Games linked with FPS genre
    (1, 2),  -- Games linked with RPG genre
    (2, 6),  -- Books linked with Fantasy genre
    (2, 7),  -- Books linked with Sci-Fi genre
    (3, 9),  -- Music linked with Rock genre
    (3, 10), -- Music linked with Pop genre
    (4, 13), -- Movies linked with Documentary genre
    (4, 14), -- Movies linked with Thriller genre
    (5, 15), -- Art linked with Abstract genre
    (5, 20), -- Art linked with Renaissance genre
    (6, 20); -- Mix linked with Renaissance genre