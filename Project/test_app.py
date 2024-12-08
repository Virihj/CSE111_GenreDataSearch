import sqlite3

def connect_to_database():
    try:
        conn = sqlite3.connect('media_library.sqlite')
        print("Connected to the database successfully!")
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
        return None

#============================================================================

def search_media(conn, category):
    try:
        if category == 'MediaType':
            search_query = "SELECT MediaTypeName FROM MediaType;"
        elif category == 'Genre':
            search_query = "SELECT GenreName FROM Genre;"
        elif category == 'Author':
            search_query = "SELECT AuthorName FROM Author;"
        elif category == 'Platform':
            search_query = "SELECT PlatformName FROM Platform;"
        else:
            print("Invalid category!")
            return

        cursor = conn.cursor()
        cursor.execute(search_query)
        results = cursor.fetchall()

        if not results:
            print(f"No {category} found.")
            return

        print(f"\nSearch results for {category}:")
        for result in results:
            print(f"- {result[0]}")

    except sqlite3.Error as e:
        print(f"Error during search: {e}")

#============================================================================

def search_items_by_category(conn, category):
    try:
        if category == 'MediaType':
            media_type_id = input("\nEnter Media Type ID to search for items (or type 'back' to return): ").strip()
            if media_type_id == 'back':
                return
            query = """
                SELECT ItemName, ReleaseYear FROM Item
                JOIN Genre ON Genre.GenreID = Item.GenreID
                JOIN MediaType ON MediaType.MediaTypeID = Genre.MediaTypeID
                WHERE MediaType.MediaTypeID = ?
            """
        elif category == 'Genre':
            genre_id = input("\nEnter Genre ID to search for items (or type 'back' to return): ").strip()
            if genre_id == 'back':
                return
            query = """
                SELECT ItemName, ReleaseYear FROM Item
                WHERE GenreID = ?
            """
        elif category == 'Author':
            author_id = input("\nEnter Author ID to search for items (or type 'back' to return): ").strip()
            if author_id == 'back':
                return
            query = """
                SELECT ItemName, ReleaseYear FROM Item
                WHERE AuthorID = ?
            """
        elif category == 'Platform':
            platform_id = input("\nEnter Platform ID to search for items (or type 'back' to return): ").strip()
            if platform_id == 'back':
                return
            query = """
                SELECT ItemName, ReleaseYear FROM Item
                WHERE PlatformID = ?
            """
        else:
            print("Invalid category!")
            return

        cursor = conn.cursor()
        cursor.execute(query, (media_type_id if category == 'MediaType' else
                              genre_id if category == 'Genre' else
                              author_id if category == 'Author' else
                              platform_id,))
        items = cursor.fetchall()

        if not items:
            print(f"No items found for {category}.")
            return

        print(f"\nItems for {category}:")
        for item in items:
            print(f"- {item[0]} (Released: {item[1]})")
    
    except sqlite3.Error as e:
        print(f"Error during search by {category}: {e}")

#============================================================================

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

#============================================================================

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

#============================================================================

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

#============================================================================

def prompt_with_list(prompt_message, list_function, conn):
    while True:
        user_input = input(prompt_message).strip()
        if user_input.lower() == "list":
            list_function(conn)
        else:
            return user_input


#============================================================================
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

#============================================================================
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

#============================================================================
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

#============================================================================
def add_item(conn):
    try:
        while True:
            print("\nYou can add data to the following tables: MediaType, Genre, Item, Author, Platform")
            table_name = input("Enter the table name to add an item to (or type 'back' to return): ").strip()

            if table_name == "back":
                return  # Exit the loop and go back to the previous prompt

            if table_name not in ["MediaType", "Genre", "Item", "Author", "Platform"]:
                print("Invalid table name. You can only add to MediaType, Genre, Item, Author, or Platform.")
                continue  # Ask for the table name again

            cursor = conn.cursor()

            if table_name == "MediaType":
                media_type_name = input("Enter MediaTypeName: ").strip()
                if media_type_name == "back":
                    continue
                if not media_type_name:
                    print("MediaTypeName cannot be empty.")
                    continue
                cursor.execute("INSERT INTO MediaType (MediaTypeName) VALUES (?)", (media_type_name,))

            elif table_name == "Genre":
                genre_name = input("Enter GenreName: ").strip()
                media_type_id = prompt_with_list(
                    "Enter MediaTypeID (or type 'list' to see available Media Types, or 'back' to go back): ",
                    list_media_types,
                    conn
                )
                if media_type_id == "back":
                    continue
                if not genre_name or not media_type_id:
                    print("GenreName and MediaTypeID cannot be empty.")
                    continue
                cursor.execute("INSERT INTO Genre (GenreName, MediaTypeID) VALUES (?, ?)", (genre_name, media_type_id))

            elif table_name == "Item":
                item_name = input("Enter ItemName: ").strip()
                release_year = input("Enter ReleaseYear: ").strip()
                genre_id = prompt_with_list(
                    "Enter GenreID (or type 'list' to see available Genres, or 'back' to go back): ",
                    list_genres,
                    conn
                )
                author_id = prompt_with_list(
                    "Enter AuthorID (or type 'list' to see available Authors, or 'back' to go back): ",
                    list_authors,
                    conn
                )
                platform_id = prompt_with_list(
                    "Enter PlatformID (or type 'list' to see available Platforms, or 'back' to go back): ",
                    list_platforms,
                    conn
                )
                age_rating_id = prompt_with_list(
                    "Enter AgeRatingID (or type 'list' to see available Age Ratings, or 'back' to go back): ",
                    list_age_ratings,
                    conn
                )
                if item_name == "back" or release_year == "back" or genre_id == "back" or author_id == "back" or platform_id == "back" or age_rating_id == "back":
                    continue
                if not item_name or not release_year or not genre_id or not author_id or not platform_id or not age_rating_id:
                    print("All fields must be filled.")
                    continue
                cursor.execute(
                    "INSERT INTO Item (ItemName, ReleaseYear, GenreID, AuthorID, PlatformID, AgeRatingID) VALUES (?, ?, ?, ?, ?, ?)",
                    (item_name, release_year, genre_id, author_id, platform_id, age_rating_id)
                )

            elif table_name == "Author":
                author_name = input("Enter AuthorName: ").strip()
                if author_name == "back":
                    continue
                if not author_name:
                    print("AuthorName cannot be empty.")
                    continue
                cursor.execute("INSERT INTO Author (AuthorName) VALUES (?)", (author_name,))

            elif table_name == "Platform":
                platform_name = input("Enter PlatformName: ").strip()
                if platform_name == "back":
                    continue
                if not platform_name:
                    print("PlatformName cannot be empty.")
                    continue
                cursor.execute("INSERT INTO Platform (PlatformName) VALUES (?)", (platform_name,))

            conn.commit()
            print(f"Data added successfully to '{table_name}'.")
            break  # Exit the loop and return after successful insertion

    except sqlite3.Error as e:
        print(f"Error adding item: {e}")

#============================================================================

def delete_item(conn):
    try:
        while True:
            print("\nYou can delete data from the following tables: MediaType, Genre, Item, Author, Platform")
            table_name = input("Enter the table name to delete an item from (or type 'back' to return): ").strip()

            if table_name == "back":
                return  # Exit the loop and go back to the previous prompt

            if table_name not in ["MediaType", "Genre", "Item", "Author", "Platform"]:
                print("Invalid table name. You can only delete from MediaType, Genre, Item, Author, or Platform.")
                continue  # Ask for the table name again

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
            elif table_name == "Author":
                column_name = "AuthorID"
                list_authors(conn)
            elif table_name == "Platform":
                column_name = "PlatformID"
                list_platforms(conn)

            value = input(f"Enter the {column_name} of the item to delete (or type 'back' to return): ").strip()

            if value == "back":
                continue  # Return to the table selection prompt

            if not value:
                print(f"{column_name} cannot be empty. Aborting operation.")
                continue  # Ask for the value again

            query = f"DELETE FROM {table_name} WHERE {column_name} = ?"
            cursor.execute(query, (value,))
            conn.commit()

            if cursor.rowcount > 0:
                print(f"Item(s) successfully deleted from '{table_name}'.")
            else:
                print(f"No matching rows found in '{table_name}'.")
            break  # Exit the loop after successful deletion

    except sqlite3.Error as e:
        print(f"Error deleting item: {e}")

#============================================================================

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
        print("6. Search for Media Types, Genres, Authors, or Platforms")
        print("7. Add Item")
        print("8. Delete Item")
        print("9. Exit")
        choice = input("Enter your choice: ").strip()

        if choice == "1":
            list_media_types(conn)
        elif choice == "2":
            list_genres(conn)
        elif choice == "3":
            list_items(conn)
        elif choice == "4":
            list_authors(conn)
        elif choice == "5":
            list_platforms(conn)
        elif choice == "6":
            category = input("\nEnter the category to search (MediaType, Genre, Author, Platform): ").strip().capitalize()
            search_media(conn, category)
        elif choice == "7":
            add_item(conn)
        elif choice == "8":
            delete_item(conn)
        elif choice == "9":
            print("Exiting...")
            break
        else:
            print("Invalid choice! Please select a valid option.")

    conn.close()

if __name__ == "__main__":
    main()
