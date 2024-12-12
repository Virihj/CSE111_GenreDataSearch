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
PRAGMA foreign_keys = ON;



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

-- Insert more data into Item Table
INSERT INTO Item (ItemName, ReleaseYear, GenreID, MediaTypeID, AuthorID, PlatformID, AgeRatingID)
VALUES
    ('The Legend of Zelda: Breath of the Wild', 2017, 2, 1, 1, 5, 1), -- RPG, Nintendo Switch, E for Everyone
    ('God of War', 2018, 2, 1, 2, 1, 2),                            -- RPG, PlayStation, M for Mature
    ('Red Dead Redemption 2', 2018, 2, 1, 3, 1, 2),                -- RPG, PlayStation, M for Mature
    ('Fortnite', 2017, 5, 1, 4, 6, 1),                             -- MOBA, Xbox, E for Everyone
    ('Cyberpunk 2077', 2020, 2, 1, 5, 2, 2),                       -- RPG, Steam, M for Mature
    ('Elden Ring', 2022, 2, 1, 6, 2, 2),                           -- RPG, Steam, M for Mature
    ('Among Us', 2018, 4, 1, 7, 2, 1),                             -- MMO, Steam, E for Everyone
    ('Genshin Impact', 2020, 2, 1, 8, 8, 1),                       -- RPG, Digital, E for Everyone
    ('Hollow Knight', 2017, 3, 1, 9, 2, 1),                        -- Story, Steam, E for Everyone
    ('Minecraft Dungeons', 2020, 3, 1, 10, 6, 1),                  -- Story, Xbox, E for Everyone
    ('Crazy in Love', 2003, 10, 3, 3, 4, 3),                       -- Pop, Beyoncé, Music, PG-13
    ('Fancy', 2010, 11, 3, 4, 4, 3),                               -- Hip-Hop, Iggy Azalea, Music, PG-13
    ('Uptown Funk', 2014, 10, 3, 5, 4, 3),                         -- Pop, Mark Ronson, Music, PG-13
    ('Lose You to Love Me', 2019, 10, 3, 6, 4, 3),                 -- Pop, Selena Gomez, Music, PG-13
    ('Harry Potter and the Sorcerers Stone', 1997, 6, 2, 11, 3, 1),-- Fantasy, J.K. Rowling, Hardcover, E for Everyone
    ('The Lightning Thief', 2005, 6, 2, 11, 3, 1),                 -- Fantasy, Rick Riordan, Hardcover, E for Everyone
    ('Spider-Man: Homecoming', 2017, 8, 4, 7, 1, 2),               -- Comic, Stan Lee, Movies/Shows, M for Mature
    ('Batman: Year One', 1987, 8, 4, 8, 1, 2),                     -- Comic, Frank Miller, Movies/Shows, M for Mature
    ('X-Men: Days of Future Past', 1981, 8, 4, 9, 1, 2),           -- Comic, Chris Claremont, Movies/Shows, M for Mature
    ('Justice League: Origin', 2011, 8, 4, 10, 1, 2),              -- Comic, Geoff Johns, Movies/Shows, M for Mature
    ('Mona Lisa', 1503, 19, 5, 11, 10, 1),                         -- Renaissance, Leonardo da Vinci, Art, E for Everyone
    ('The Last Supper', 1498, 19, 5, 11, 10, 1),                   -- Renaissance, Leonardo da Vinci, Art, E for Everyone
    ('Starry Night', 1889, 19, 5, 12, 10, 1),                      -- Renaissance, Vincent van Gogh, Art, E for Everyone
    ('Girl with a Pearl Earring', 1665, 19, 5, 13, 10, 1),         -- Renaissance, Johannes Vermeer, Art, E for Everyone
    ('The Creation of Adam', 1512, 19, 5, 14, 10, 1);              -- Renaissance, Michelangelo, Art, E for Everyone

-- Insert more data into Author Table
INSERT INTO Author (AuthorID, AuthorName)
VALUES
    (1, 'Nintendo'),
    (2, 'Santa Monica Studio'),
    (3, 'Rockstar Games'),
    (4, 'Epic Games'),
    (5, 'CD Projekt Red'),
    (6, 'FromSoftware'),
    (7, 'Innersloth'),
    (8, 'miHoYo'),
    (9, 'Team Cherry'),
    (10, 'Mojang Studios'),
    (11, 'J.K. Rowling'),
    (12, 'Vincent van Gogh'),
    (13, 'Johannes Vermeer'),
    (14, 'Michelangelo'),
    (15, 'Beyoncé'),
    (16, 'Iggy Azalea'),
    (17, 'Mark Ronson'),
    (18, 'Selena Gomez'),
    (19, 'Stan Lee'),
    (20, 'Frank Miller'),
    (21, 'Chris Claremont'),
    (22, 'Geoff Johns');

-- Insert data into ItemAuthor Table to link items with authors
INSERT INTO ItemAuthor (ItemID, AuthorID)
VALUES
    (1, 1), -- The Legend of Zelda: Breath of the Wild by Nintendo
    (2, 2), -- God of War by Santa Monica Studio
    (3, 3), -- Red Dead Redemption 2 by Rockstar Games
    (4, 4), -- Fortnite by Epic Games
    (5, 5), -- Cyberpunk 2077 by CD Projekt Red
    (6, 6), -- Elden Ring by FromSoftware
    (7, 7), -- Among Us by Innersloth
    (8, 8), -- Genshin Impact by miHoYo
    (9, 9), -- Hollow Knight by Team Cherry
    (10, 10), -- Minecraft Dungeons by Mojang Studios
    (11, 15), -- Crazy in Love by Beyoncé
    (12, 16), -- Fancy by Iggy Azalea
    (13, 17), -- Uptown Funk by Mark Ronson
    (14, 18), -- Lose You to Love Me by Selena Gomez
    (15, 11), -- Harry Potter and the Sorcerers Stone by J.K. Rowling
    (16, 11), -- The Lightning Thief by Rick Riordan
    (17, 19), -- Spider-Man: Homecoming by Stan Lee
    (18, 20), -- Batman: Year One by Frank Miller
    (19, 21), -- X-Men: Days of Future Past by Chris Claremont
    (20, 22); -- Justice League: Origin by Geoff Johns

-- Insert additional data into ItemPlatform Table
INSERT OR IGNORE INTO ItemPlatform (ItemID, PlatformID)
VALUES
    (1, 5),
    (2, 1),
    (3, 1),
    (4, 6),
    (5, 2),
    (6, 2),
    (7, 2),
    (8, 8),
    (9, 2),
    (10, 6),
    (11, 4),
    (12, 4),
    (13, 4),
    (14, 4),
    (15, 3),
    (16, 3),
    (17, 1),
    (18, 1),
    (19, 1),
    (20, 1),
    (21, 10),
    (22, 10),
    (23, 10),
    (24, 10),
    (25, 10);


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
    Author.AuthorName LIKE '%AuthorName%';             -- Renaissance, Art
