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

-- Insert data into MediaType Table, including ID 7 for "Mix"
INSERT INTO MediaType (MediaTypeName)
VALUES 
    ('Games'),          --1
    ('Books'),          --2
    ('Music'),          --3
    ('Movies/Shows'),   --4
    ('Art'),            --5
    ('Podcasts'),       --6
    ('Mix');            --7

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
<<<<<<< HEAD
    ('Metal', 3),        -- Music
    ('Documentary', 4),  -- Movies/Shows
    ('Thriller', 4),     -- Movies/Shows
    ('Romance', 7),      -- Mix, for multiple media types
    ('Comedy', 7),       -- Mix, for multiple media types
    ('Action', 7),       -- Mix, for multiple media types
    ('Abstract', 5),     -- Art
    ('Realism', 5),      -- Art
    ('Surrealism', 5),   -- Art
    ('Impressionism', 5); -- Art
=======
    ('Superhero', 5),    -- Comics
    ('Renaissance', 6);  -- Art
>>>>>>> 21dd8241b8b6be1aa5fde18d8a815ba9e7fe9784

-- Insert data into Item Table
INSERT INTO Item (ItemName, ReleaseYear, GenreID)
VALUES 
<<<<<<< HEAD
    ('God of War', 2018, 2),     -- RPG, Games
    ('Dune', 1965, 7),           -- Sci-Fi, Books
    ('Crazy in Love', 2003, 10); -- Pop, Music
=======
    ('God of War', 2018, 2),                           -- RPG, Games
    ('Dune', 1965, 4),                                 -- Sci-Fi, Books
    ('Crazy in Love', 2003, 6),                        -- Pop, Music
    ('Fancy', 2010, 7),                                -- Hip-Hop, Music
    ('Uptown Funk', 2014, 6),                          -- Pop, Music
    ('Lose You to Love Me', 2019, 6),                  -- Pop, Music
    ('Harry Potter and the Sorcerers Stone', 1997, 3),  -- Fantasy, Books
    ('The Lightning Thief', 2005, 3),                  -- Fantasy, Books
    ('Super Mario Odyssey', 2017, 1),                  -- Platformer, Games
    ('Sonic the Hedgehog', 1991, 1),                   -- Platformer, Games
    ('Spider-Man: Homecoming', 2017, 8),               -- Superhero, Comics
    ('Batman: Year One', 1987, 8),                     -- Superhero, Comics
    ('X-Men: Days of Future Past', 1981, 8),           -- Superhero, Comics
    ('Justice League: Origin', 2011, 8),               -- Superhero, Comics
    ('Mona Lisa', 1503, 9),                            -- Renaissance, Art
    ('The Last Supper', 1498, 9),                      -- Renaissance, Art
    ('Starry Night', 1889, 9),                         -- Renaissance, Art
    ('Girl with a Pearl Earring', 1665, 9),            -- Renaissance, Art
    ('The Creation of Adam', 1512, 9);                 -- Renaissance, Art
>>>>>>> 21dd8241b8b6be1aa5fde18d8a815ba9e7fe9784

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

-- Insert data into MediaTypeGenre Table, using MediaTypeID = 7 (Mix) for common genres
INSERT INTO MediaTypeGenre (MediaTypeID, GenreID)
VALUES 
    (1, 1),  -- Games linked with FPS genre
    (1, 2),  -- Games linked with RPG genre
<<<<<<< HEAD
    (2, 6),  -- Books linked with Fantasy genre
    (2, 7),  -- Books linked with Sci-Fi genre
    (3, 9),  -- Music linked with Rock genre
    (3, 10), -- Music linked with Pop genre
    (4, 15), -- Movies/Shows linked with Documentary genre
    (7, 16), -- Mix linked with Romance genre
    (7, 17); -- Mix linked with Comedy genre
=======
    (2, 3),  -- Books linked with Fantasy genre
    (2, 4),  -- Books linked with Sci-Fi genre
    (3, 5),  -- Music linked with Rock genre
    (3, 6),  -- Music linked with Pop genre
    (3, 7),  -- Music linked with Hip-Hop genre
    (5, 8),  -- Comics linked with Superhero genre
    (6, 9);  -- Art linked with Renaissance genre
>>>>>>> 21dd8241b8b6be1aa5fde18d8a815ba9e7fe9784

-- Insert data into ItemAgeRating Table to link items to their age ratings
INSERT INTO ItemAgeRating (ItemID, AgeRatingID)
VALUES 
    (1, 2),  -- God of War has M for Mature rating
    (2, 3),  -- Dune has PG-13 rating
    (3, 1),  -- Crazy in Love has E for Everyone rating
    (4, 1),  -- Fancy has E for Everyone rating
    (5, 1),  -- Uptown Funk has E for Everyone rating
    (6, 1),  -- Lose You to Love Me has E for Everyone rating
    (7, 1),  -- Harry Potter has E for Everyone rating
    (8, 1),  -- The Lightning Thief has E for Everyone rating
    (9, 1),  -- Super Mario Odyssey has E for Everyone rating
    (10, 1), -- Sonic the Hedgehog has E for Everyone rating
    (11, 3), -- Spider-Man: Homecoming has PG-13 rating
    (12, 3), -- Batman: Year One has PG-13 rating
    (13, 3), -- X-Men: Days of Future Past has PG-13 rating
    (14, 3); -- Justice League: Origin has PG-13 rating
