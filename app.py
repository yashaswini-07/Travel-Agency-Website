import os
from flask import Flask, render_template, request, redirect, url_for, session, jsonify
import mysql.connector

app = Flask(__name__)
app.secret_key = 'travelgo_super_secure_session_key'

# =====================================================================
# MYSQL PERMANENT DATABASE STORAGE INTERFACE CONFIGURATION
# =====================================================================
db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': 'Yashaswini2007',
    'database': 'travel_agency1'
}

def get_db_connection():
    return mysql.connector.connect(**db_config)


# =====================================================================
# PASSENGER PORTAL AUTHENTICATION
# =====================================================================
@app.route('/', methods=['GET', 'POST'])
@app.route('/login', methods=['GET', 'POST'])
def user_login():
    msg = None
    if request.method == 'POST':
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '')
        
        try:
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)
            query = "SELECT * FROM customers WHERE email = %s AND phone_number = %s"
            cursor.execute(query, (email, password))
            user = cursor.fetchone()
            cursor.close()
            conn.close()
            
            if user:
                session['user_logged_in'] = True
                session['user_email'] = user['email']
                session['user_name'] = user['name']
                return redirect(url_for('home'))
            else:
                msg = "Access Denied: Invalid Email Credentials or Password Key."
        except Exception as e:
            msg = f"Database Error: {str(e)}"
            
    return render_template('user_login.html', msg=msg)


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    error = None
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip()
        password = request.form.get('password', '')
        address = request.form.get('address', '').strip()
        
        try:
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.execute("SELECT customerid FROM customers WHERE email = %s", (email,))
            if cursor.fetchone():
                error = "An account profile with this email identifier already exists!"
            else:
                insert_query = """
                    INSERT INTO customers (name, email, phone_number, address) 
                    VALUES (%s, %s, %s, %s)
                """
                cursor.execute(insert_query, (name, email, password, address))
                conn.commit()
                
                session['user_logged_in'] = True
                session['user_email'] = email
                session['user_name'] = name
                return redirect(url_for('home'))
            cursor.close()
            conn.close()
        except Exception as e:
            error = f"Database Write Failure: {str(e)}"
            
    return render_template('signup.html', error=error)


# =====================================================================
# SYSTEM SEARCH ENGINE & ALL-TRAIN DISPLAY MODULE
# =====================================================================
@app.route('/home', methods=['GET', 'POST'])
def home():
    if not session.get('user_logged_in'):
        return redirect(url_for('user_login'))
        
    matched_trains = []
    source = request.form.get('source', '').strip() if request.method == 'POST' else None
    destination = request.form.get('destination', '').strip() if request.method == 'POST' else None
    is_search_applied = False
    
    source_cities = []
    destination_cities = []
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        # FIXED: Explicitly sorting by the selected aliases ('src' and 'dest') to prevent MySQL 3065 Strict Mode error
        cursor.execute("SELECT DISTINCT TRIM(source) as src FROM trains WHERE source IS NOT NULL AND source != '' ORDER BY src ASC")
        source_cities = [row['src'] for row in cursor.fetchall()]
        
        cursor.execute("SELECT DISTINCT TRIM(destination) as dest FROM trains WHERE destination IS NOT NULL AND destination != '' ORDER BY dest ASC")
        destination_cities = [row['dest'] for row in cursor.fetchall()]
        
        # Determine display data pattern based on form submission
        if request.method == 'POST' and source and destination:
            is_search_applied = True
            query = "SELECT * FROM trains WHERE LOWER(TRIM(source)) = %s AND LOWER(TRIM(destination)) = %s ORDER BY id DESC"
            cursor.execute(query, (source.lower(), destination.lower()))
            matched_trains = cursor.fetchall()
        else:
            # REAL-TIME DEFAULT: Show all operational trains across the board
            cursor.execute("SELECT * FROM trains ORDER BY id DESC")
            matched_trains = cursor.fetchall()
            
        cursor.close()
        conn.close()
    except Exception as e:
        return f"Operational Error: {str(e)}"
            
    return render_template(
        'home.html', 
        source_cities=source_cities, 
        destination_cities=destination_cities, 
        trains=matched_trains, 
        source=source, 
        destination=destination,
        is_search_applied=is_search_applied
    )


@app.route('/book-train', methods=['POST'])
def book_train():
    if not session.get('user_logged_in'):
        return jsonify({"error": "Unauthorized session context"}), 401
        
    passenger_email = session.get('user_email')
    passenger_name = session.get('user_name')
    train_name = request.form.get('train_name')
    train_number = request.form.get('train_number')
    source = request.form.get('source')
    destination = request.form.get('destination')
    departure = request.form.get('departure_time')
    selected_seats = request.form.get('selected_seats', '').strip()
    price_paid = request.form.get('price_paid', '0')

    if not selected_seats:
        return "<h3>Selection Error: Please pick at least one seat to complete your booking.</h3>"

    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        sql = """
            INSERT INTO bookings (passenger_email, passenger_name, train_name, train_number, source, destination, departure, seats_reserved, price_paid)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(sql, (passenger_email, passenger_name, train_name, train_number, source, destination, departure, selected_seats, price_paid))
        conn.commit()
        cursor.close()
        conn.close()
        return redirect(url_for('home', booking_success='true', seats=selected_seats))
    except Exception as e:
        return f"<h3>Failed to commit booking logs: {str(e)}</h3>"


# =====================================================================
# ADMINISTRATIVE CORE MODULE (SECURE CONTROL PANEL)
# =====================================================================
@app.route('/admin', methods=['GET', 'POST'])
def admin_login():
    msg = None
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '')
        
        if username == 'root_admin' and password == 'admin123':
            session['admin_logged_in'] = True
            session['admin_user'] = username
            return redirect(url_for('admin_dashboard'))
        else:
            msg = "System Firewall Flag: Invalid Security Credentials."
            
    return render_template('admin_login.html', msg=msg)


@app.route('/admin/dashboard')
def admin_dashboard():
    if not session.get('admin_logged_in'):
        return redirect(url_for('admin_login'))
        
    customers_list = []
    trains_list = []
    
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT * FROM customers")
        customers_list = cursor.fetchall()
        
        cursor.execute("SELECT * FROM trains ORDER BY id DESC")
        trains_list = cursor.fetchall()
        
        cursor.close()
        conn.close()
    except Exception as e:
        return f"<h3>Database Synchronization Failure: {str(e)}</h3>"
        
    return render_template('admin_dashboard.html', customers_list=customers_list, trains_list=trains_list)


@app.route('/admin/add-train', methods=['GET', 'POST'])
def add_new_train():
    if not session.get('admin_logged_in'):
        return redirect(url_for('admin_login'))
        
    if request.method == 'POST':
        train_name = request.form.get('train_name')
        train_number = request.form.get('train_number')
        source = request.form.get('source')
        destination = request.form.get('destination')
        departure_time = request.form.get('departure_time')
        price = request.form.get('price')
        
        try:
        
            conn = get_db_connection()
            cursor = conn.cursor()
            query = """
                INSERT INTO trains (train_name, train_number, source, destination, departure_time, price)
                VALUES (%s, %s, %s, %s, %s, %s)
            """
            cursor.execute(query, (train_name, train_number, source, destination, departure_time, price))
            conn.commit()
            cursor.close()
            conn.close()
            return redirect(url_for('admin_dashboard'))
        except Exception as e:
            print(f"Failed to append dynamic fleet entries to database: {e}")
            
    return render_template('add_train.html')


@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('user_login'))


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000, debug=True)