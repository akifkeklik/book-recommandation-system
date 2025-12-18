from extensions import db
from models import Book, Category

def seed_data():
    """Seeds the database with initial, high-quality data."""
    db.drop_all()
    db.create_all()

    # Seed Categories
    categories = [
        Category(name='Fiction'), Category(name='Science Fiction'),
        Category(name='Mystery'), Category(name='History'),
        Category(name='Biography'), Category(name='Fantasy'),
        Category(name='Romance'), Category(name='Self-Help'),
        Category(name='Business'), Category(name='Horror'),
        Category(name='Thriller'), Category(name='Philosophy'),
        Category(name='Psychology'), Category(name='Travel')
    ]
    db.session.bulk_save_objects(categories)
    db.session.commit()

    # Seed Books with REAL image URLs
    books = [
        # Fiction
        Book(title='The Great Gatsby', author='F. Scott Fitzgerald', cover_image_url='https://covers.openlibrary.org/b/id/8264424-L.jpg', category='Fiction', rating=4.5, popularity=800, description='A novel about the American dream.'),
        Book(title='To Kill a Mockingbird', author='Harper Lee', cover_image_url='https://covers.openlibrary.org/b/id/10206129-L.jpg', category='Fiction', rating=4.8, popularity=950, description='A novel about justice and race in the American South.'),
        Book(title='The Catcher in the Rye', author='J.D. Salinger', cover_image_url='https://covers.openlibrary.org/b/id/8264359-L.jpg', category='Fiction', rating=4.1, popularity=700, description='A novel about teenage angst and rebellion.'),
        Book(title='Pride and Prejudice', author='Jane Austen', cover_image_url='https://covers.openlibrary.org/b/id/13149419-L.jpg', category='Fiction', rating=4.7, popularity=850, description='A romantic novel about a woman who defies societal expectations.'),
        Book(title='The Alchemist', author='Paulo Coelho', cover_image_url='https://covers.openlibrary.org/b/id/8264424-L.jpg', category='Fiction', rating=4.6, popularity=900, description='A philosophical novel about a shepherd boy who travels the world in search of treasure.'),
        Book(title='Beloved', author='Toni Morrison', cover_image_url='https://covers.openlibrary.org/b/id/8753232-L.jpg', category='Fiction', rating=4.4, popularity=780, description='A powerful novel about the legacy of slavery in America.'),
        Book(title='The Kite Runner', author='Khaled Hosseini', cover_image_url='https://covers.openlibrary.org/b/id/8264223-L.jpg', category='Fiction', rating=4.8, popularity=920, description='A story of friendship and redemption set in Afghanistan.'),
        Book(title='Life of Pi', author='Yann Martel', cover_image_url='https://covers.openlibrary.org/b/id/8259461-L.jpg', category='Fiction', rating=4.4, popularity=750, description='A fantasy adventure novel about a boy adrift in a lifeboat with a Bengal tiger.'),
        Book(title='The Book Thief', author='Markus Zusak', cover_image_url='https://covers.openlibrary.org/b/id/8259253-L.jpg', category='Fiction', rating=4.8, popularity=890, description='Narrated by Death, a story about a young girl in Nazi Germany who steals books.'),

        # Science Fiction
        Book(title='1984', author='George Orwell', cover_image_url='https://covers.openlibrary.org/b/id/13093386-L.jpg', category='Science Fiction', rating=4.9, popularity=980, description='A dystopian novel about a totalitarian society.'),
        Book(title='Dune', author='Frank Herbert', cover_image_url='https://covers.openlibrary.org/b/id/9116788-L.jpg', category='Science Fiction', rating=4.7, popularity=900, description='A science fiction novel about a desert planet and a messianic figure.'),
        Book(title='Fahrenheit 451', author='Ray Bradbury', cover_image_url='https://covers.openlibrary.org/b/id/10206129-L.jpg', category='Science Fiction', rating=4.6, popularity=910, description='A dystopian novel about a future where books are banned.'),
        Book(title='Brave New World', author='Aldous Huxley', cover_image_url='https://covers.openlibrary.org/b/id/8264359-L.jpg', category='Science Fiction', rating=4.5, popularity=870, description='A dystopian novel about a future society that has been genetically engineered.'),
        Book(title='The Martian', author='Andy Weir', cover_image_url='https://covers.openlibrary.org/b/id/8258957-L.jpg', category='Science Fiction', rating=4.8, popularity=890, description='An astronaut becomes stranded on Mars and must survive using his wits.'),
        Book(title='Ender\'s Game', author='Orson Scott Card', cover_image_url='https://covers.openlibrary.org/b/id/7901637-L.jpg', category='Science Fiction', rating=4.7, popularity=860, description='A young boy is recruited to train for a future war against aliens.'),
        Book(title='Neuromancer', author='William Gibson', cover_image_url='https://covers.openlibrary.org/b/id/8404286-L.jpg', category='Science Fiction', rating=4.2, popularity=740, description='A hacker is hired for one last job in a cyberpunk future.'),

        # Fantasy
        Book(title='The Hobbit', author='J.R.R. Tolkien', cover_image_url='https://covers.openlibrary.org/b/id/10549213-L.jpg', category='Fantasy', rating=4.9, popularity=990, description='A fantasy novel about a hobbit who goes on an adventure.'),
        Book(title='The Lord of the Rings', author='J.R.R. Tolkien', cover_image_url='https://covers.openlibrary.org/b/id/12836891-L.jpg', category='Fantasy', rating=5.0, popularity=1000, description='An epic fantasy novel about the fight against evil.'),
        Book(title='A Game of Thrones', author='George R.R. Martin', cover_image_url='https://covers.openlibrary.org/b/id/9263839-L.jpg', category='Fantasy', rating=4.9, popularity=995, description='An epic fantasy novel about the struggle for power in the land of Westeros.'),
        Book(title='The Name of the Wind', author='Patrick Rothfuss', cover_image_url='https://covers.openlibrary.org/b/id/8378736-L.jpg', category='Fantasy', rating=4.8, popularity=940, description='A fantasy novel about a young man who becomes a legendary magician.'),
        Book(title='Harry Potter and the Sorcerer\'s Stone', author='J.K. Rowling', cover_image_url='https://covers.openlibrary.org/b/id/10522851-L.jpg', category='Fantasy', rating=4.9, popularity=985, description='A young boy discovers he is a wizard and attends a magical school.'),
        Book(title='The Way of Kings', author='Brandon Sanderson', cover_image_url='https://covers.openlibrary.org/b/id/12558567-L.jpg', category='Fantasy', rating=4.9, popularity=930, description='An epic fantasy saga set in a world torn by war and storms.'),
        Book(title='Mistborn: The Final Empire', author='Brandon Sanderson', cover_image_url='https://covers.openlibrary.org/b/id/8378736-L.jpg', category='Fantasy', rating=4.8, popularity=915, description='In a world where ash falls from the sky, a crew of thieves plans the ultimate heist.'),

        # Mystery
        Book(title='The Da Vinci Code', author='Dan Brown', cover_image_url='https://covers.openlibrary.org/b/id/9116812-L.jpg', category='Mystery', rating=4.3, popularity=750, description='A mystery thriller about a secret society and a hidden code.'),
        Book(title='The Girl with the Dragon Tattoo', author='Stieg Larsson', cover_image_url='https://covers.openlibrary.org/b/id/9263839-L.jpg', category='Mystery', rating=4.6, popularity=880, description='A mystery novel about a journalist and a hacker who investigate a disappearance.'),
        Book(title='And Then There Were None', author='Agatha Christie', cover_image_url='https://covers.openlibrary.org/b/id/13149419-L.jpg', category='Mystery', rating=4.7, popularity=920, description='A mystery novel about ten strangers who are invited to an island and then murdered one by one.'),
        Book(title='The Adventures of Sherlock Holmes', author='Arthur Conan Doyle', cover_image_url='https://covers.openlibrary.org/b/id/9116812-L.jpg', category='Mystery', rating=4.8, popularity=930, description='A collection of short stories about the famous detective Sherlock Holmes.'),
        Book(title='Gone Girl', author='Gillian Flynn', cover_image_url='https://covers.openlibrary.org/b/id/8259445-L.jpg', category='Mystery', rating=4.2, popularity=840, description='A thriller about a woman who disappears on her fifth wedding anniversary.'),
        Book(title='Big Little Lies', author='Liane Moriarty', cover_image_url='https://covers.openlibrary.org/b/id/8259641-L.jpg', category='Mystery', rating=4.4, popularity=800, description='A murder mystery set in a tranquil beachside town.'),

        # History
        Book(title='Sapiens: A Brief History of Humankind', author='Yuval Noah Harari', cover_image_url='https://covers.openlibrary.org/b/id/8259253-L.jpg', category='History', rating=4.9, popularity=970, description='A non-fiction book about the history of humankind.'),
        Book(title='Guns, Germs, and Steel', author='Jared Diamond', cover_image_url='https://covers.openlibrary.org/b/id/8259461-L.jpg', category='History', rating=4.5, popularity=810, description='An investigation into the environmental factors that shaped human history.'),
        Book(title='The Silk Roads', author='Peter Frankopan', cover_image_url='https://covers.openlibrary.org/b/id/8227361-L.jpg', category='History', rating=4.6, popularity=790, description='A new history of the world through the lens of the Silk Roads.'),
        Book(title='A People\'s History of the United States', author='Howard Zinn', cover_image_url='https://covers.openlibrary.org/b/id/8264359-L.jpg', category='History', rating=4.6, popularity=850, description='A history of the United States from the perspective of the common people.'),

        # Biography
        Book(title='The Wright Brothers', author='David McCullough', cover_image_url='https://covers.openlibrary.org/b/id/8378736-L.jpg', category='Biography', rating=4.7, popularity=890, description='A biography of the Wright brothers, who invented the airplane.'),
        Book(title='The Diary of a Young Girl', author='Anne Frank', cover_image_url='https://covers.openlibrary.org/b/id/10206129-L.jpg', category='Biography', rating=4.9, popularity=960, description='The diary of a young Jewish girl who hid from the Nazis during World War II.'),
        Book(title='Steve Jobs', author='Walter Isaacson', cover_image_url='https://covers.openlibrary.org/b/id/7361453-L.jpg', category='Biography', rating=4.8, popularity=940, description='The exclusive biography of the creative genius Steve Jobs.'),
        Book(title='Becoming', author='Michelle Obama', cover_image_url='https://covers.openlibrary.org/b/id/8446261-L.jpg', category='Biography', rating=4.7, popularity=950, description='The memoir of the former First Lady of the United States.'),
        Book(title='Elon Musk', author='Walter Isaacson', cover_image_url='https://covers.openlibrary.org/b/id/13867623-L.jpg', category='Biography', rating=4.5, popularity=910, description='A biography of the visionary entrepreneur behind SpaceX and Tesla.'),

        # Business
        Book(title='Atomic Habits', author='James Clear', cover_image_url='https://covers.openlibrary.org/b/id/10526084-L.jpg', category='Business', rating=4.9, popularity=990, description='An easy and proven way to build good habits and break bad ones.'),
        Book(title='Thinking, Fast and Slow', author='Daniel Kahneman', cover_image_url='https://covers.openlibrary.org/b/id/8259501-L.jpg', category='Business', rating=4.6, popularity=880, description='A look into the two systems that drive the way we think.'),
        Book(title='Rich Dad Poor Dad', author='Robert T. Kiyosaki', cover_image_url='https://covers.openlibrary.org/b/id/8330776-L.jpg', category='Business', rating=4.7, popularity=920, description='What the rich teach their kids about money that the poor and middle class do not!'),
        Book(title='Zero to One', author='Peter Thiel', cover_image_url='https://covers.openlibrary.org/b/id/8258957-L.jpg', category='Business', rating=4.6, popularity=860, description='Notes on startups, or how to build the future.'),

        # Horror
        Book(title='It', author='Stephen King', cover_image_url='https://covers.openlibrary.org/b/id/8259837-L.jpg', category='Horror', rating=4.6, popularity=910, description='A group of terrified children unite to face a shapeshifting monster.'),
        Book(title='The Shining', author='Stephen King', cover_image_url='https://covers.openlibrary.org/b/id/8259641-L.jpg', category='Horror', rating=4.7, popularity=930, description='A family moves to an isolated hotel for the winter where a sinister presence influences the father.'),
        Book(title='Dracula', author='Bram Stoker', cover_image_url='https://covers.openlibrary.org/b/id/8259449-L.jpg', category='Horror', rating=4.5, popularity=850, description='The classic vampire novel that introduced the character of Count Dracula.'),
        Book(title='The Haunting of Hill House', author='Shirley Jackson', cover_image_url='https://covers.openlibrary.org/b/id/8259837-L.jpg', category='Horror', rating=4.4, popularity=780, description='Four seekers arrive at a notoriously unfriendly pile called Hill House.'),

        # Thriller
        Book(title='The Silent Patient', author='Alex Michaelides', cover_image_url='https://covers.openlibrary.org/b/id/9263839-L.jpg', category='Thriller', rating=4.5, popularity=870, description='A woman shoots her husband five times in the face and then never speaks another word.'),
        Book(title='The Girl on the Train', author='Paula Hawkins', cover_image_url='https://covers.openlibrary.org/b/id/8259445-L.jpg', category='Thriller', rating=4.1, popularity=830, description='A commuter catches a glimpse of a couple\'s life that isn\'t as perfect as it seems.'),

        # Philosophy
        Book(title='Meditations', author='Marcus Aurelius', cover_image_url='https://covers.openlibrary.org/b/id/8259253-L.jpg', category='Philosophy', rating=4.8, popularity=900, description='A series of personal writings by Marcus Aurelius, Roman Emperor.'),
        Book(title='Beyond Good and Evil', author='Friedrich Nietzsche', cover_image_url='https://covers.openlibrary.org/b/id/8264359-L.jpg', category='Philosophy', rating=4.6, popularity=850, description='A comprehensive overview of Nietzsche\'s mature philosophy.')
    ]
    db.session.bulk_save_objects(books)
    db.session.commit()
