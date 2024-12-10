DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS MediaType;
DROP TABLE IF EXISTS ItemAgeRating;
DROP TABLE IF EXISTS Platform;
DROP TABLE IF EXISTS MediaTypeGenre;
DROP TABLE IF EXISTS AgeRating;
DROP TABLE IF EXISTS Media;
DROP TABLE IF EXISTS Author;
DROP TABLE IF EXISTS ItemGenre;
DROP TABLE IF EXISTS ItemAuthor;


-- 1. Create MediaType Table
CREATE TABLE MediaType (
    MediaTypeID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeName TEXT NOT NULL
);

-- 1.1. Create Genre
CREATE TABLE Genre (
    GenreID INTEGER PRIMARY KEY AUTOINCREMENT,
    GenreName TEXT NOT NULL,
    MediaTypeID INTEGER NOT NULL,
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID)
);

-- 2. Create Genre Table (Allow for a "Mix" Genre with MediaTypeID = 7)
CREATE TABLE Media (
    MediaID INTEGER PRIMARY KEY AUTOINCREMENT,
    Title TEXT NOT NULL,
    GenreID INTEGER,
    MediaTypeID INTEGER,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID)
);

--3 Create Item Table
CREATE TABLE Item (
    ItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemName TEXT NOT NULL, 
    ReleaseYear INTEGER,
    GenreID INTEGER,
    MediaTypeID INTEGER,
    AuthorID INTEGER,
    PlatformID INTEGER,
    AgeRatingID INTEGER,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (PlatformID) REFERENCES Platform(PlatformID),
    FOREIGN KEY (AgeRatingID) REFERENCES AgeRating(AgeRatingID)
);

-- 5 Create Platform Table
CREATE TABLE Platform (
    PlatformID INTEGER PRIMARY KEY AUTOINCREMENT,
    PlatformName TEXT NOT NULL
);

-- 6 Create AgeRating Table
CREATE TABLE AgeRating (
    AgeRatingID INTEGER PRIMARY KEY AUTOINCREMENT,
    AgeRatingName TEXT NOT NULL
);

-- 7 Create MediaTypeGenre Table (Junction Table for MediaType and Genre)
CREATE TABLE MediaTypeGenre (
    MediaTypeGenreID INTEGER PRIMARY KEY AUTOINCREMENT,
    MediaTypeID INTEGER NOT NULL,
    GenreID INTEGER NOT NULL,
    FOREIGN KEY (MediaTypeID) REFERENCES MediaType(MediaTypeID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    UNIQUE (MediaTypeID, GenreID) -- Ensure each MediaType-Genre combination is unique
);

-- 8 Create Author Table
CREATE TABLE Author (
    AuthorID INTEGER PRIMARY KEY AUTOINCREMENT,
    AuthorName TEXT NOT NULL
);

--9 Create Junction Table for Item and Author
CREATE TABLE ItemAuthor (
    ItemAuthorID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemID INTEGER NOT NULL,
    AuthorID INTEGER NOT NULL,
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    UNIQUE (ItemID, AuthorID) -- Ensure each Item-Author combination is unique
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


-- 15 Insert data into Platform Table
INSERT INTO Platform (PlatformID, PlatformName)
VALUES 
    (1, 'PlayStation'),       -- 1
    (2, 'Steam'),             -- 2
    (3, 'Hardcover'),         -- 3
    (4, 'Spotify'),           -- 4
    (5, 'Nintendo Switch'),   -- 5
    (6, 'Xbox'),              -- 6
    (7, 'Apple Books'),       -- 7
    (8, 'Digital'),           -- 8
    (9, 'Trade Paperback'),   -- 9
    (10, 'Museum');           -- 10

-- 16 Insert data into AgeRating Table
INSERT INTO AgeRating (AgeRatingID, AgeRatingName)
VALUES 
    (1, 'E for Everyone'),    -- 1
    (2, 'M for Mature'),      -- 2
    (3, 'PG-13'),             -- 3
    (4, 'R');                 -- 4

-- 17 Insert data into Author Table
INSERT INTO Author (AuthorID, AuthorName)
VALUES 
    (1, 'David Jaffe'),       -- 1 Creator of God of War
    (2, 'Frank Herbert'),     -- 2 Author of Dune
    (3, 'Beyoncé'),           -- 3 Artist for Crazy in Love
    (4, 'Iggy Azalea'),       -- 4 Artist for Fancy
    (5, 'Mark Ronson'),       -- 5 Artist for Uptown Funk
    (6, 'Selena Gomez'),      -- 6 Artist for Lose You to Love Me
    (7, 'Stan Lee'),          -- 7 Writer for Spider-Man: Homecoming
    (8, 'Frank Miller'),      -- 8 Writer for Batman: Year One
    (9, 'Chris Claremont'),   -- 9 Writer for X-Men: Days of Future Past
    (10, 'Geoff Johns'),      -- 10 Writer for Justice League: Origin
    (11, 'Leonardo da Vinci'),-- 11 Painter of The Last Supper
    (12, 'Johannes Vermeer'), -- 12 Painter of Girl with a Pearl Earring
    (13, 'Michelangelo');     -- 13 Painter of The Creation of Adam



-- Insert more data into Item Table
INSERT INTO Item (ItemName, ReleaseYear, GenreID, MediaTypeID, AuthorID, PlatformID, AgeRatingID)
VALUES 
    ('Crazy in Love', 2003, 10, 3, 2, 3, 3),             -- Pop, AuthorID: Beyoncé, Music, T for Teen
    ('Fancy', 2010, 11, 3, 2, 3, 3),                    -- Hip-Hop, AuthorID: Iggy Azalea, Music, T for Teen
    ('Uptown Funk', 2014, 10, 3, 2, 3, 3),              -- Pop, AuthorID: Mark Ronson, Music, T for Teen
    ('Lose You to Love Me', 2019, 10, 3, 2, 3, 3),      -- Pop, AuthorID: Selena Gomez, Music, T for Teen
    ('Harry Potter and the Sorcerers Stone', 1997, 6, 2, 3, 1, 1), -- Fantasy, AuthorID: J.K. Rowling, Hardcover, E for Everyone
    ('The Lightning Thief', 2005, 6, 2, 3, 1, 1),       -- Fantasy, AuthorID: Rick Riordan, Hardcover, E for Everyone
    ('Super Mario Odyssey', 2017, 1, 1, 1, 2, 2),       -- FPS, AuthorID: Nintendo, Games, M for Mature
    ('Sonic the Hedgehog', 1991, 1, 1, 1, 2, 2),        -- FPS, AuthorID: SEGA, Games, M for Mature
    ('Spider-Man: Homecoming', 2017, 8, 4, 3, 2, 2),    -- Comic, AuthorID: Marvel, Movies/Shows, M for Mature
    ('Batman: Year One', 1987, 8, 4, 3, 2, 2),          -- Comic, AuthorID: DC, Movies/Shows, M for Mature
    ('X-Men: Days of Future Past', 1981, 8, 4, 3, 2, 2), -- Comic, AuthorID: Marvel, Movies/Shows, M for Mature
    ('Justice League: Origin', 2011, 8, 4, 3, 2, 2),    -- Comic, AuthorID: DC, Movies/Shows, M for Mature
    ('Mona Lisa', 1503, 19, 5, 4, 1, 1),                -- Renaissance, AuthorID: Leonardo da Vinci, Art, E for Everyone
    ('The Last Supper', 1498, 19, 5, 4, 1, 1),          -- Renaissance, AuthorID: Leonardo da Vinci, Art, E for Everyone
    ('Starry Night', 1889, 19, 5, 4, 1, 1),             -- Renaissance, AuthorID: Vincent van Gogh, Art, E for Everyone
    ('Girl with a Pearl Earring', 1665, 19, 5, 4, 1, 1), -- Renaissance, AuthorID: Johannes Vermeer, Art, E for Everyone
    ('The Creation of Adam', 1512, 19, 5, 4, 1, 1);     -- Renaissance, AuthorID: Michelangelo, Art, E for Everyone


-- --14 Insert data into Item Table
-- INSERT INTO Item (ItemName, ReleaseYear, GenreID)
-- VALUES 
--     ('God of War', 2018, 2),                           -- RPG, Games
--     ('Dune', 1965, 7),                                 -- Sci-Fi, Books
--     ('Crazy in Love', 2003, 10),                       -- Pop, Music
--     ('Fancy', 2010, 11),                               -- Hip-Hop, Music
--     ('Uptown Funk', 2014, 10),                         -- Pop, Music
--     ('Lose You to Love Me', 2019, 10),                 -- Pop, Music
--     ('Harry Potter and the Sorcerers Stone', 1997, 6), -- Fantasy, Books
--     ('The Lightning Thief', 2005, 6),                  -- Fantasy, Books
--     ('Super Mario Odyssey', 2017, 1),                  -- FPS, Games
--     ('Sonic the Hedgehog', 1991, 1),                   -- FPS, Games
--     ('Spider-Man: Homecoming', 2017, 8),               -- Comic, Books
--     ('Batman: Year One', 1987, 8),                     -- Comic, Books
--     ('X-Men: Days of Future Past', 1981, 8),           -- Comic, Books
--     ('Justice League: Origin', 2011, 8),               -- Comic, Books
--     ('Mona Lisa', 1503, 19),                           -- Renaissance, Art
--     ('The Last Supper', 1498, 19),                     -- Renaissance, Art
--     ('Starry Night', 1889, 19),                        -- Renaissance, Art
--     ('Girl with a Pearl Earring', 1665, 19),           -- Renaissance, Art
--     ('The Creation of Adam', 1512, 19);                -- Renaissance, Art


--1 updated query for searching items by authors
SELECT 
    Item.ItemName, 
    Item.ReleaseYear, 
    Author.AuthorName
FROM 
    Item
JOIN 
    ItemAuthor ON Item.ItemID = ItemAuthor.ItemID -- Use ItemID for the join
JOIN 
    Author ON ItemAuthor.AuthorID = Author.AuthorID
WHERE 
    Author.AuthorName LIKE '%AuthorName%';