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

            # Insert into Item table
            cursor.execute("INSERT INTO Item (ItemName, ReleaseYear, GenreID) VALUES (?, ?, ?)", (item_name, release_year, genre_id))
            item_id = cursor.lastrowid

            # Insert Author
            cursor.execute("INSERT OR IGNORE INTO Author (AuthorName) VALUES (?)", (author_name,))
            author_id = cursor.lastrowid

            # Link Item and Author
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
        print("4. Add an Item")
        print("5. Delete an Item")
        print("6. Exit")
        print("=" * 40)
        choice = input("Enter your choice (1-6): ").strip()

        if choice == '1':
            list_media_types(conn)
        elif choice == '2':
            list_genres(conn)
        elif choice == '3':
            list_items(conn)
        elif choice == '4':
            add_item(conn)
        elif choice == '5':
            delete_item(conn)
        elif choice == '6':
            print("\nThank you for using Media Library Manager!")
            break
        else:
            print("Invalid choice. Please try again.")

    conn.close()

if __name__ == "__main__":
    main()
