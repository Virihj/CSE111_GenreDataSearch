-- 1. Select all media types
SELECT * FROM MediaType;

-- 2. Select all genres associated with books
SELECT GenreName FROM Genre 
WHERE MediaTypeID = (SELECT MediaTypeID FROM MediaType WHERE MediaTypeName = 'Books');

-- 3. Find items released after the year 2000
SELECT ItemName FROM Item WHERE ReleaseYear > 2000;

-- 4. Find items available on 'PlayStation'
SELECT ItemName FROM Item 
JOIN ItemPlatform ON Item.ItemID = ItemPlatform.ItemID
JOIN Platform ON ItemPlatform.PlatformID = Platform.PlatformID
WHERE Platform.PlatformName = 'PlayStation';

-- 5. Find genres under 'Games' media type
SELECT GenreName FROM Genre
JOIN MediaType ON Genre.MediaTypeID = MediaType.MediaTypeID
WHERE MediaType.MediaTypeName = 'Games';

-- 6. Update item 'God of War' release year to 2017
UPDATE Item SET ReleaseYear = 2017 WHERE ItemName = 'God of War';

-- 7. Add a new platform 'Xbox'
INSERT INTO Platform (PlatformName) VALUES ('Xbox');

-- 8. Link 'God of War' with 'Xbox'
INSERT INTO ItemPlatform (ItemID, PlatformID) 
VALUES ((SELECT ItemID FROM Item WHERE ItemName = 'God of War'), 
        (SELECT PlatformID FROM Platform WHERE PlatformName = 'Xbox'));

-- 9. Find items available on multiple platforms
SELECT ItemName, COUNT(PlatformID) AS PlatformCount 
FROM ItemPlatform
GROUP BY ItemID
HAVING COUNT(PlatformID) > 1;

-- 10. Add a new genre 'Adventure' for 'Games'
INSERT INTO Genre (GenreName, MediaTypeID) 
VALUES ('Adventure', (SELECT MediaTypeID FROM MediaType WHERE MediaTypeName = 'Games'));

-- 11. Assign 'Adventure' genre to 'God of War'
UPDATE Item 
SET GenreID = (SELECT GenreID FROM Genre WHERE GenreName = 'Adventure') 
WHERE ItemName = 'God of War';

-- 12. Delete the 'R' age rating
DELETE FROM AgeRating WHERE AgeRatingName = 'R';

-- 13. Find all items with age rating 'M for Mature'
SELECT ItemName FROM Item 
JOIN ItemAgeRating ON Item.ItemID = ItemAgeRating.ItemID
JOIN AgeRating ON ItemAgeRating.AgeRatingID = AgeRating.AgeRatingID
WHERE AgeRating.AgeRatingName = 'M for Mature';

-- 14. List all platforms for each item
SELECT ItemName, PlatformName FROM Item
JOIN ItemPlatform ON Item.ItemID = ItemPlatform.ItemID
JOIN Platform ON ItemPlatform.PlatformID = Platform.PlatformID;

-- 15. Add a new item 'Cyberpunk' as a game in the RPG genre
INSERT INTO Item (ItemName, ReleaseYear, GenreID) 
VALUES ('Cyberpunk', 2020, (SELECT GenreID FROM Genre WHERE GenreName = 'RPG'));

-- 16. Link 'Cyberpunk' with 'Steam Platform' and 'Xbox'
INSERT INTO ItemPlatform (ItemID, PlatformID) VALUES 
    ((SELECT ItemID FROM Item WHERE ItemName = 'Cyberpunk'), 
     (SELECT PlatformID FROM Platform WHERE PlatformName = 'Steam Platform')),
    ((SELECT ItemID FROM Item WHERE ItemName = 'Cyberpunk'), 
     (SELECT PlatformID FROM Platform WHERE PlatformName = 'Xbox'));

-- 17. Find all items in the 'Fantasy' genre
SELECT ItemName FROM Item
JOIN Genre ON Item.GenreID = Genre.GenreID
WHERE Genre.GenreName = 'Fantasy';

-- 18. Update platform name from 'Steam' to 'Steam Platform'
UPDATE Platform SET PlatformName = 'Steam Platform' WHERE PlatformName = 'Steam';

-- 19. Delete the 'Cyberpunk' item
DELETE FROM Item WHERE ItemName = 'Cyberpunk';

-- 20. Find all items along with their age ratings
SELECT ItemName, AgeRatingName FROM Item
JOIN ItemAgeRating ON Item.ItemID = ItemAgeRating.ItemID
JOIN AgeRating ON ItemAgeRating.AgeRatingID = AgeRating.AgeRatingID;

-- 21. Find the authors of items
SELECT ItemName, AuthorName FROM Item
JOIN ItemAuthor ON Item.ItemID = ItemAuthor.ItemID
JOIN Author ON ItemAuthor.AuthorID = Author.AuthorID;