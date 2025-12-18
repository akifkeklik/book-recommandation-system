from flask import Blueprint, jsonify
from models import Book
from recommendation import get_recommendations as ml_get_recommendations

recommendations_bp = Blueprint('recommendations_bp', __name__)

@recommendations_bp.route('/recommendations/<int:user_id>', methods=['GET'])
def get_recommendations(user_id):
    # 1. Fetch all books from DB
    all_books = Book.query.all()

    # Convert to dictionary format for the ML engine
    all_books_data = [{
        'id': book.id,
        'title': book.title,
        'author': book.author,
        'cover_image_url': book.cover_image_url,
        'category': book.category,
        'rating': book.rating,
        'popularity': book.popularity,
        'description': book.description
    } for book in all_books]

    # 2. Ask the ML Brain for recommendations
    # It will look at the user's interaction history in the DB
    recommended_books_data = ml_get_recommendations(user_id, all_books_data)

    return jsonify(recommended_books_data)
