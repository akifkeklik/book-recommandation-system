import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from models import Book, UserInteraction

# V2.0: Machine Learning Based Recommendation Engine
def get_recommendations(user_id, all_books_data):
    """
    Generates content-based recommendations using TF-IDF and Cosine Similarity.
    
    1. Analyzes book descriptions and categories.
    2. Builds a profile of what the user likes based on their interactions.
    3. Finds books mathematically similar to that profile.
    """
    
    # 1. Fetch user interactions (What did they like?)
    user_likes = UserInteraction.query.filter_by(user_id=user_id, interaction_type='favorite').all()
    liked_book_ids = [interaction.book_id for interaction in user_likes]

    # If user hasn't liked anything yet, fallback to popularity (Hybrid approach)
    if not liked_book_ids:
        # Sort by popularity descending
        return sorted(all_books_data, key=lambda x: x['popularity'], reverse=True)[:10]

    # 2. Prepare Data for ML
    # We combine Title, Category, and Description to create a rich "Content Tag" for each book
    book_contents = []
    for book in all_books_data:
        # "The Hobbit Fantasy A hobbit goes on an adventure..."
        content = f"{book['title']} {book['category']} {book['description']}"
        book_contents.append(content)

    # 3. Vectorization (Convert Text to Numbers)
    # TF-IDF penalizes common words (like "the", "a") and boosts unique keywords
    tfidf = TfidfVectorizer(stop_words='english')
    tfidf_matrix = tfidf.fit_transform(book_contents)

    # 4. Calculate Similarity Matrix
    # This creates a grid showing how similar every book is to every other book
    cosine_sim = cosine_similarity(tfidf_matrix, tfidf_matrix)

    # 5. Generate User Recommendations
    # We'll sum up the similarity scores of all books similar to the ones the user liked
    
    # Map book IDs to their index in the matrix
    id_to_index = {book['id']: idx for idx, book in enumerate(all_books_data)}
    
    # Create an array to store aggregate scores for all books
    num_books = len(all_books_data)
    user_scores = np.zeros(num_books)

    for liked_id in liked_book_ids:
        if liked_id in id_to_index:
            idx = id_to_index[liked_id]
            # Add the similarity scores of this liked book to the total
            user_scores += cosine_sim[idx]

    # 6. Rank and Filter
    # Get indices of books sorted by score (descending)
    sorted_indices = user_scores.argsort()[::-1]

    recommended_books = []
    count = 0
    for idx in sorted_indices:
        book = all_books_data[idx]
        
        # Don't recommend books the user has already liked
        if book['id'] in liked_book_ids:
            continue
            
        recommended_books.append(book)
        count += 1
        if count >= 10: # Return top 10
            break
            
    return recommended_books
