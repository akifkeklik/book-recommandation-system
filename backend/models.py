from extensions import db

class Book(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    author = db.Column(db.String(100), nullable=False)
    cover_image_url = db.Column(db.String(200), nullable=False)
    category = db.Column(db.String(50), nullable=False)
    rating = db.Column(db.Float, nullable=False)
    popularity = db.Column(db.Integer, nullable=False)
    description = db.Column(db.Text, nullable=False)

class Category(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=False)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    # Storing category preferences as a simple JSON string list "[1, 2]"
    preferred_category_ids = db.Column(db.String(200), default="[]")

# V2.0: Interaction Table for ML
class UserInteraction(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    book_id = db.Column(db.Integer, db.ForeignKey('book.id'), nullable=False)
    interaction_type = db.Column(db.String(20), nullable=False) # 'favorite' or 'read'
    
    # Ensure a user can't favorite the same book twice
    __table_args__ = (db.UniqueConstraint('user_id', 'book_id', 'interaction_type', name='_user_book_interaction_uc'),)
