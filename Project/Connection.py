from flask import Flask, render_template, request, redirect, jsonify
import sqlite3

app = Flask(__name__)

# Database connection
def db_connection():
    try:
        conn = sqlite3.connect("media.db")
        conn.row_factory = sqlite3.Row
        return conn
    except sqlite3.Error as e:
        print(f"Database connection error: {e}")
        return None

# Home route
@app.route('/')
def home():
    return render_template('home.html')

# Add media
@app.route('/add', methods=['POST'])
def add_media():
    data = request.form
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO Item (ItemName, MediaTypeID, GenreID, ReleaseYear) 
            VALUES (?, 
                    (SELECT MediaTypeID FROM MediaType WHERE MediaTypeName = ?), 
                    (SELECT GenreID FROM Genre WHERE GenreName = ?), 
                    ?)
        """, (data['media_name'], data['media_type'], data['genre'], data['release_year']))
        conn.commit()
    except sqlite3.Error as e:
        print(f"Error adding media: {e}")
        return jsonify({"error": "Database error occurred"}), 500
    finally:
        if conn:
            conn.close()
    return redirect('/')

# Search media
@app.route('/search', methods=['GET'])
def search_media():
    search_term = request.args.get('search_term', '')
    try:
        conn = db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT ItemName, MediaTypeName, GenreName, ReleaseYear 
            FROM Item
            JOIN MediaType ON Item.MediaTypeID = MediaType.MediaTypeID
            JOIN Genre ON Item.GenreID = Genre.GenreID
            WHERE ItemName LIKE ?
        """, ('%' + search_term + '%',))
        results = cursor.fetchall()
    except sqlite3.Error as e:
        print(f"Error searching media: {e}")
        return jsonify({"error": "Database error occurred"}), 500
    finally:
        if conn:
            conn.close()
    return jsonify([dict(row) for row in results])

if __name__ == '__main__':
    app.run(debug=True)
