from flask import Flask
from extensions import db
from database import init_db
from seed import seed_data

def create_app():
    """Construct the core application."""
    # 1. Create the Flask app instance
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///books.db'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    # 2. Initialize extensions
    # The 'db' object from extensions.py is now tied to the app.
    db.init_app(app)

    # 3. Import and register blueprints
    # These are imported *after* the app is created and configured.
    from routes.books import books_bp
    from routes.users import users_bp
    from routes.recommendations import recommendations_bp
    app.register_blueprint(books_bp)
    app.register_blueprint(users_bp)
    app.register_blueprint(recommendations_bp)

    # 4. Create an application context before running database operations
    with app.app_context():
        # Initialize and seed the database
        # This ensures that the application context is available for db.create_all()
        # V2.0: Only re-seed if force is needed, but for now we re-seed to apply changes
        init_db()
        seed_data() 

    # 5. Return the fully configured app instance
    return app

# This is the main entry point for the application
if __name__ == "__main__":
    # The app is created by calling our factory function
    app = create_app()
    # The server is started
    # Host must be 0.0.0.0 to be accessible from Android Emulator (via 10.0.2.2)
    app.run(host='0.0.0.0', port=5000, debug=True)
