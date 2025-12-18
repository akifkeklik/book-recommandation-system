from flask_sqlalchemy import SQLAlchemy

# This creates the SQLAlchemy instance without attaching it to an app yet.
# It acts as a central point for the rest of the application to access the database.
db = SQLAlchemy()
