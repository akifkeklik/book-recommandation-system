from flask import Blueprint, jsonify
from models import Book, Category

books_bp = Blueprint('books_bp', __name__)

@books_bp.route('/books', methods=['GET'])
def get_books():
    books = Book.query.all()
    return jsonify([{
        'id': book.id,
        'title': book.title,
        'author': book.author,
        'cover_image_url': book.cover_image_url,
        'category': book.category,
        'rating': book.rating,
        'popularity': book.popularity,
        'description': book.description
    } for book in books])

@books_bp.route('/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
    book = Book.query.get_or_404(book_id)
    return jsonify({
        'id': book.id,
        'title': book.title,
        'author': book.author,
        'cover_image_url': book.cover_image_url,
        'category': book.category,
        'rating': book.rating,
        'popularity': book.popularity,
        'description': book.description
    })

# V4.1: New efficient endpoint for fetching books by category
@books_bp.route('/books/category/<string:category_name>', methods=['GET'])
def get_books_by_category(category_name):
    books = Book.query.filter_by(category=category_name).all()
    return jsonify([{
        'id': book.id,
        'title': book.title,
        'author': book.author,
        'cover_image_url': book.cover_image_url,
        'category': book.category,
        'rating': book.rating,
        'popularity': book.popularity,
        'description': book.description
    } for book in books])


@books_bp.route('/categories', methods=['GET'])
def get_categories():
    categories = Category.query.all()
    return jsonify([{
        'id': category.id,
        'name': category.name
    } for category in categories])
