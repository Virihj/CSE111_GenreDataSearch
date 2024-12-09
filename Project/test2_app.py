import sqlite3

def connect_to_database():
    try:
        conn = sqlite3.connect('media_library.sqlite')
        print("Connected to the database successfully!")
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
        return None

def list_media_types(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT MediaTypeID, MediaTypeName FROM MediaType;")
        media_types = cursor.fetchall()
        print("\nAvailable Media Types:")
        for media in media_types:
            print(f"- ID: {media[0]}, Name: {media[1]}")
    except sqlite3.Error as e:
        print(f"Error retrieving media types: {e}")

def list_genres(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT GenreID, GenreName FROM Genre;")
        genres = cursor.fetchall()
        print("\nAvailable Genres:")
        for genre in genres:
            print(f"- ID: {genre[0]}, Name: {genre[1]}")
    except sqlite3.Error as e:
        print(f"Error retrieving genres: {e}")

def list_items(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM Item;")
        items = cursor.fetchall()
        print("Available Items:")
        for item in items:
            print(item)
    except sqlite3.Error as e:
        print(f"Error retrieving items: {e}")

def prompt_with_list(prompt_message, list_function, conn):
    while True:
        user_input = input(prompt_message).strip()
        if user_input.lower() == "list":
            list_function(conn)
        else:
            return user_input

def list_authors(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT AuthorID, AuthorName FROM Author;")
        authors = cursor.fetchall()
        print("\nAvailable Authors:")
        for author in authors:
            print(f"- ID: {author[0]}, Name: {author[1]}")
    except sqlite3.Error as e:
        print(f"Error retrieving authors: {e}")


def list_platforms(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT PlatformID, PlatformName FROM Platform;")
        platforms = cursor.fetchall()
        print("\nAvailable Platforms:")
        for platform in platforms:
            print(f"- ID: {platform[0]}, Name: {platform[1]}")
    except sqlite3.Error as e:
        print(f"Error retrieving platforms: {e}")

def list_age_ratings(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT AgeRatingID, AgeRatingName FROM AgeRating;")
        age_ratings = cursor.fetchall()
        print("\nAvailable Age Ratings:")
        for rating in age_ratings:
            print(f"- ID: {rating[0]}, Name: {rating[1]}")
    except sqlite3.Error as e:
        print(f"Error retrieving age ratings: {e}")


def add_item(conn):
    try:
        print("\nYou can add data to the following tables: MediaType, Genre, Item")
        table_name = input("Enter the table name to add an item to: ").strip()

        if table_name not in ["MediaType", "Genre", "Item"]:
            print("Invalid table name. You can only add to MediaType, Genre, or Item.")
            return

        cursor = conn.cursor()

        if table_name == "MediaType":
            media_type_name = input("Enter MediaTypeName: ").strip()
            if not media_type_name:
                print("MediaTypeName cannot be empty.")
                return
            cursor.execute("INSERT INTO MediaType (MediaTypeName) VALUES (?)", (media_type_name,))

        elif table_name == "Genre":
            genre_name = input("Enter GenreName: ").strip()
            media_type_id = prompt_with_list(
                "Enter MediaTypeID (or type 'list' to see available Media Types): ",
                list_media_types,
                conn
            )
            if not genre_name or not media_type_id:
                print("GenreName and MediaTypeID cannot be empty.")
                return
            cursor.execute("INSERT INTO Genre (GenreName, MediaTypeID) VALUES (?, ?)", (genre_name, media_type_id))

        elif table_name == "Item":
            item_name = input("Enter ItemName: ").strip()
            release_year = input("Enter ReleaseYear: ").strip()
            genre_id = prompt_with_list(
                "Enter GenreID (or type 'list' to see available Genres): ",
                list_genres,
                conn
            )
            author_name = input("Enter AuthorName: ").strip()
            if not item_name or not release_year or not genre_id or not author_name:
                print("ItemName, ReleaseYear, GenreID, and AuthorName cannot be empty.")
                return

            cursor.execute("INSERT INTO Item (ItemName, ReleaseYear, GenreID) VALUES (?, ?, ?)", (item_name, release_year, genre_id))
            item_id = cursor.lastrowid

            cursor.execute("INSERT OR IGNORE INTO Author (AuthorName) VALUES (?)", (author_name,))
            author_id = cursor.lastrowid

            cursor.execute("INSERT INTO ItemAuthor (ItemID, AuthorID) VALUES (?, ?)", (item_id, author_id))

        conn.commit()
        print(f"Data added successfully to '{table_name}'.")
    except sqlite3.Error as e:
        print(f"Error adding item: {e}")

def delete_item(conn):
    try:
        print("\nYou can delete data from the following tables: MediaType, Genre, Item")
        table_name = input("Enter the table name to delete an item from: ").strip()

        if table_name not in ["MediaType", "Genre", "Item"]:
            print("Invalid table name. You can only delete from MediaType, Genre, or Item.")
            return

        cursor = conn.cursor()

        if table_name == "MediaType":
            column_name = "MediaTypeID"
            list_media_types(conn)
        elif table_name == "Genre":
            column_name = "GenreID"
            list_genres(conn)
        elif table_name == "Item":
            column_name = "ItemID"
            list_items(conn)

        value = input(f"Enter the {column_name} of the item to delete: ").strip()

        if not value:
            print(f"{column_name} cannot be empty. Aborting operation.")
            return

        query = f"DELETE FROM {table_name} WHERE {column_name} = ?"
        cursor.execute(query, (value,))
        conn.commit()

        if cursor.rowcount > 0:
            print(f"Item(s) successfully deleted from '{table_name}'.")
        else:
            print(f"No matching rows found in '{table_name}'.")
    except sqlite3.Error as e:
        print(f"Error deleting item: {e}")

def search_items_by_table(conn):
    try:
        print("\nSelect a table to search:")
        print("1. Item")
        print("2. Genre")
        print("3. Platform")
        print("4. Author")
        table_choice = input("Enter the table number to search (1-4): ").strip()

        if table_choice == '1':
            item_name = input("Enter Item Name (or part of it): ").strip()
            query = """
            SELECT 
                i.ItemName, 
                i.ReleaseYear, 
                g.GenreName, 
                m.MediaTypeName, 
                a.AuthorName
            FROM Item i
            LEFT JOIN Genre g ON i.GenreID = g.GenreID
            LEFT JOIN MediaType m ON g.MediaTypeID = m.MediaTypeID
            LEFT JOIN ItemAuthor ia ON i.ItemID = ia.ItemID
            LEFT JOIN Author a ON ia.AuthorID = a.AuthorID
            WHERE (? = '' OR i.ItemName LIKE '%' || ? || '%')
            """
            cursor = conn.cursor()
            cursor.execute(query, (item_name, item_name))
            results = cursor.fetchall()

            if results:
                print("\nSearch Results:")
                for result in results:
                    print(f"Item Name: {result[0]}, Release Year: {result[1]}, Genre: {result[2]}, Media Type: {result[3]}, Author: {result[4]}")
            else:
                print("No items found matching the criteria.")

        elif table_choice == '2':
            genre_name = input("Enter Genre Name (or part of it): ").strip()
            query = """
            SELECT 
                i.ItemName, 
                i.ReleaseYear, 
                g.GenreName, 
                m.MediaTypeName, 
                a.AuthorName
            FROM Item i
            LEFT JOIN Genre g ON i.GenreID = g.GenreID
            LEFT JOIN MediaType m ON g.MediaTypeID = m.MediaTypeID
            LEFT JOIN ItemAuthor ia ON i.ItemID = ia.ItemID
            LEFT JOIN Author a ON ia.AuthorID = a.AuthorID
            WHERE (? = '' OR g.GenreName LIKE '%' || ? || '%')
            """
            cursor = conn.cursor()
            cursor.execute(query, (genre_name, genre_name))
            results = cursor.fetchall()

            if results:
                print("\nSearch Results:")
                for result in results:
                    print(f"Item Name: {result[0]}, Release Year: {result[1]}, Genre: {result[2]}, Media Type: {result[3]}, Author: {result[4]}")
            else:
                print("No items found matching the criteria.")

        elif table_choice == '3':
            platform_name = input("Enter Platform Name (or part of it): ").strip()
            query = """
            SELECT 
                p.PlatformName, 
                i.ItemName, 
                i.ReleaseYear, 
                g.GenreName, 
                a.AuthorName
            FROM Platform p
            LEFT JOIN ItemPlatform ip ON p.PlatformID = ip.PlatformID
            LEFT JOIN Item i ON ip.ItemID = i.ItemID
            LEFT JOIN Genre g ON i.GenreID = g.GenreID
            LEFT JOIN ItemAuthor ia ON i.ItemID = ia.ItemID
            LEFT JOIN Author a ON ia.AuthorID = a.AuthorID
            WHERE (? = '' OR p.PlatformName LIKE '%' || ? || '%')
            """
            cursor = conn.cursor()
            cursor.execute(query, (platform_name, platform_name))
            results = cursor.fetchall()

            if results:
                print("\nSearch Results:")
                for result in results:
                    print(f"Platform Name: {result[0]}, Item Name: {result[1]}, Release Year: {result[2]}, Genre: {result[3]}, Author: {result[4]}")
            else:
                print("No platforms found matching the criteria.")

        elif table_choice == '4':
            author_name = input("Enter Author Name (or part of it): ").strip()
            query = """
            SELECT 
                a.AuthorName, 
                i.ItemName, 
                i.ReleaseYear, 
                g.GenreName, 
                m.MediaTypeName
            FROM Author a
            LEFT JOIN ItemAuthor ia ON a.AuthorID = ia.AuthorID
            LEFT JOIN Item i ON ia.ItemID = i.ItemID
            LEFT JOIN Genre g ON i.GenreID = g.GenreID
            LEFT JOIN MediaType m ON g.MediaTypeID = m.MediaTypeID
            WHERE (? = '' OR a.AuthorName LIKE '%' || ? || '%')
            """
            cursor = conn.cursor()
            cursor.execute(query, (author_name, author_name))
            results = cursor.fetchall()

            if results:
                print("\nSearch Results:")
                for result in results:
                    print(f"Author Name: {result[0]}, Item Name: {result[1]}, Release Year: {result[2]}, Genre: {result[3]}, Media Type: {result[4]}")
            else:
                print("No authors found matching the criteria.")

        else:
            print("Invalid choice. Please select a valid table number (1-4).")

    except sqlite3.Error as e:
        print(f"Error searching items: {e}")

def main():
    conn = connect_to_database()
    if not conn:
        return

    while True:
        print("\n" + "=" * 40)
        print("          MEDIA LIBRARY MANAGER")
        print("=" * 40)
        print("1. List Media Types")
        print("2. List Genres")
        print("3. List Items")
        print("4. List Authors")
        print("5. List Platforms")
        print("6. Add an Item")
        print("7. Delete an Item")
        print("8. Search for Items")
        print("9. Exit")
        print("=" * 40)
        choice = input("Enter your choice (1-7): ").strip()

        if choice == '1':
            list_media_types(conn)
        elif choice == '2':
            list_genres(conn)
        elif choice == '3':
            list_items(conn)
        elif choice == '4':
            list_authors(conn)
        elif choice == '5':
            list_platforms(conn)
        elif choice == '6':
            add_item(conn)
        elif choice == '7':
            delete_item(conn)
        elif choice == '8':
            search_items_by_table(conn)
        elif choice == '9':
            print("\nThank you for using Media Library Manager!")
            break
        else:
            print("Invalid choice. Please try again.")

    conn.close()

if __name__ == "__main__":
    main()
