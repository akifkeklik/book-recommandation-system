from flask import Blueprint, request, jsonify
from extensions import db
from models import User, UserInteraction, Book

users_bp = Blueprint('users_bp', __name__)

@users_bp.route('/users/preferences', methods=['POST'])
def save_preferences():
    data = request.get_json()
    user_id = data.get('user_id')
    preferred_category_ids = data.get('preferred_category_ids')

    user = User.query.get(user_id)
    if not user:
        # Create a new user if not exists (for demo simplicity)
        user = User(id=user_id, preferred_category_ids=str(preferred_category_ids))
        db.session.add(user)
    else:
        user.preferred_category_ids = str(preferred_category_ids)
    
    db.session.commit()
    return jsonify({'message': 'Preferences saved successfully'}), 200

# V2.0: Interaction API (Like/Read)
@users_bp.route('/users/interact', methods=['POST'])
def interact_with_book():
    """
    Records a user's interaction (favorite or read) with a book.
    This data feeds the ML engine.
    """
    data = request.get_json()
    user_id = data.get('user_id')
    book_id = data.get('book_id')
    interaction_type = data.get('type') # 'favorite' or 'read'

    if not all([user_id, book_id, interaction_type]):
        return jsonify({'error': 'Missing data'}), 400

    # Check if interaction already exists
    existing = UserInteraction.query.filter_by(
        user_id=user_id, book_id=book_id, interaction_type=interaction_type
    ).first()

    if existing:
        # Toggle: If it exists, remove it (Unlike)
        db.session.delete(existing)
        action = 'removed'
    else:
        # Add new interaction
        new_interaction = UserInteraction(
            user_id=user_id, book_id=book_id, interaction_type=interaction_type
        )
        db.session.add(new_interaction)
        action = 'added'

    db.session.commit()
    return jsonify({'message': f'Interaction {action}', 'action': action}), 200
