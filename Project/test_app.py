import sqlite3

def connect_to_database():
    try:
        # Connect to the SQLite database file 'tpch.sqlite'
        conn = sqlite3.connect('tpch.sqlite')
        print("Connected to the database successfully!")
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
        return None

def list_tables(conn):
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()
        print("\nTables in the database:")
        for table in tables:
            print(f"- {table[0]}")
    except sqlite3.Error as e:
        print(f"Error retrieving tables: {e}")

def describe_table(conn, table_name):
    try:
        cursor = conn.cursor()
        cursor.execute(f"PRAGMA table_info({table_name});")
        columns = cursor.fetchall()
        if columns:
            print(f"\nColumns in table '{table_name}':")
            for column in columns:
                print(f"- {column[1]} ({column[2]})")
        else:
            print(f"Table '{table_name}' does not exist or has no columns.")
    except sqlite3.Error as e:
        print(f"Error describing table: {e}")

def add_item(conn):
    try:
        table_name = input("Enter the table name to add an item to: ").strip()
        if not table_name:
            print("Table name cannot be empty.")
            return

        cursor = conn.cursor()
        cursor.execute(f"PRAGMA table_info({table_name});")
        columns = cursor.fetchall()
        if not columns:
            print(f"Table '{table_name}' does not exist or has no columns.")
            return

        values = []
        for column in columns:
            if column[5] == 1:  # Check if the column is NOT NULL
                value = input(f"Enter value for {column[1]} ({column[2]}) [Required]: ").strip()
                if not value:
                    print(f"{column[1]} is required. Aborting operation.")
                    return
            else:
                value = input(f"Enter value for {column[1]} ({column[2]}) [Optional]: ").strip()
            values.append(value if value else None)

        placeholders = ", ".join(["?" for _ in values])
        query = f"INSERT INTO {table_name} VALUES ({placeholders})"
        cursor.execute(query, values)
        conn.commit()
        print(f"Item added successfully to '{table_name}'.")
    except sqlite3.Error as e:
        print(f"Error adding item: {e}")

def main():
    conn = connect_to_database()
    if not conn:
        return

    while True:
        print("\nMenu:")
        print("1. List All Tables")
        print("2. Describe a Table")
        print("3. Add an Item")
        print("4. Exit")
        choice = input("Select an option: ").strip()

        if choice == '1':
            list_tables(conn)
        elif choice == '2':
            table_name = input("Enter table name: ").strip()
            if table_name:
                describe_table(conn, table_name)
            else:
                print("Table name cannot be empty. Please try again.")
        elif choice == '3':
            add_item(conn)
        elif choice == '4':
            print("Exiting the application.")
            break
        else:
            print("Invalid choice. Please try again.")

    conn.close()

if __name__ == "__main__":
    main()
