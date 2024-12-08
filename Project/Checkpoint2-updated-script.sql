DROP TABLE IF EXISTS ItemAuthor;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS ItemPlatform;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS MediaType;
DROP TABLE IF EXISTS Platform;
DROP TABLE IF EXISTS MediaTypeGenre;
DROP TABLE IF EXISTS AgeRating;
DROP TABLE IF EXISTS ItemAgeRating;
DROP TABLE IF EXISTS Media;

-- 1. Create MediaType Table
CREATE TABLE MediaType (
    MediaTypeID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeName TEXT NOT NULL
);

-- 1.1. Create Genre
CREATE TABLE Genre (
    GenreID INTEGER PRIMARY KEY,
    GenreName TEXT NOT NULL
);

-- 2. Create Genre Table (Allow for a "Mix" Genre with MediaTypeID = 7)
CREATE TABLE Media (
    MediaID INTEGER PRIMARY KEY,
    Title TEXT NOT NULL,
    GenreID INTEGER,
    MediaTypeID INTEGER,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
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

-- 9. Create Author Table
CREATE TABLE Author (
    AuthorID INTEGER PRIMARY KEY AUTOINCREMENT,
    AuthorName TEXT NOT NULL
);

-- 10. Create ItemAuthor Table (Junction Table for Item and Author)
CREATE TABLE ItemAuthor (
    ItemAuthorID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemID INTEGER NOT NULL,
    AuthorID INTEGER NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    UNIQUE (ItemID, AuthorID) -- Ensure unique pairing of Item and Author
);

--11 Insert data into MediaType Table, including ID 6 for "Mix"
INSERT INTO MediaType (MediaTypeName)
VALUES 
    ('Games'),          --1
    ('Books'),          --2
    ('Music'),          --3
    ('Movies/Shows'),   --4
    ('Art'),            --5
    ('Mix');            --6

--12 To add the column MediaTypeID to the Genre table    
ALTER TABLE Genre
ADD MediaTypeID INT;

--13 Insert data into Genre Table
INSERT INTO Genre (GenreName, MediaTypeID)
VALUES 
    ('FPS', 1),          -- Games 1
    ('RPG', 1),          -- Games 2
    ('Story', 1),        -- Games 3
    ('MMO', 1),          -- Games 4
    ('MOBA', 1),         -- Games 5
    ('Fantasy', 2),      -- Books 6
    ('Sci-Fi', 2),       -- Books 7
    ('Comic', 2),        -- Books 8
    ('Rock', 3),         -- Music 9
    ('Pop', 3),          -- Music 10
    ('Hip-Hop', 3),      -- Music 11
    ('Metal', 3),        -- Music 12
    ('Documentary', 4),  -- Movies/Shows 13
    ('Thriller', 4),     -- Movies/Shows 14
    ('Abstract', 5),     -- Art 15
    ('Realism', 5),      -- Art 16
    ('Surrealism', 5),   -- Art 17
    ('Impressionism', 5),-- Art 18
    ('Renaissance', 5),  -- Art 19
    ('Romance', 6),      -- Mix 20
    ('Comedy', 6),       -- Mix 21
    ('Action', 6);       -- Mix 22

--14 Insert data into Item Table
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
    ('Mona Lisa', 1503, 19),                           -- Renaissance, Art
    ('The Last Supper', 1498, 19),                     -- Renaissance, Art
    ('Starry Night', 1889, 19),                        -- Renaissance, Art
    ('Girl with a Pearl Earring', 1665, 19),           -- Renaissance, Art
    ('The Creation of Adam', 1512, 19);                -- Renaissance, Art

--15 Insert data into Platform Table
INSERT INTO Platform (PlatformName)
VALUES 
    ('PlayStation'), --1
    ('Steam'), --2
    ('Hardcover'), --3
    ('Spotify'), --4
    ('Nintendo Switch'), --5
    ('Xbox'), --6
    ('Apple Books'), --7
    ('Digital'), --8
    ('Trade Paperback'), --9
    ('Museum'); --10

--16 Insert data into AgeRating Table
INSERT INTO AgeRating (AgeRatingName)
VALUES 
    ('E for Everyone'),
    ('M for Mature'),
    ('PG-13'),
    ('R');

--17 Insert data into Author Table
INSERT INTO Author (AuthorName)
VALUES 
    ('David Jaffe'),          -- Creator of God of War
    ('Frank Herbert'),        -- Author of Dune
    ('Beyoncé'),              -- Artist for Crazy in Love
    ('Iggy Azalea'),          -- Artist for Fancy
    ('Mark Ronson'),          -- Artist for Uptown Funk
    ('Selena Gomez'),         -- Artist for Lose You to Love Me
    ('Stan Lee'),             -- Writer for Spider-Man: Homecoming
    ('Frank Miller'),         -- Writer for Batman: Year One
    ('Chris Claremont'),      -- Writer for X-Men: Days of Future Past
    ('Geoff Johns'),          -- Writer for Justice League: Origin
    ('Leonardo da Vinci'),    -- Painter of The Last Supper
    ('Johannes Vermeer'),     -- Painter of Girl with a Pearl Earring
    ('Michelangelo');         -- Painter of The Creation of Adam

--18 Insert data into ItemAuthor Table to link items with authors
INSERT INTO ItemAuthor (ItemID, AuthorID)
VALUES 
    (1, 5),   -- God of War by David Jaffe
    (2, 6),   -- Dune by Frank Herbert
    (3, 7),   -- Crazy in Love by Beyoncé
    (4, 8),   -- Fancy by Iggy Azalea
    (5, 9),   -- Uptown Funk by Mark Ronson
    (6, 10)
