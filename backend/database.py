from extensions import db

def init_db():
    # This function will now be called within an application context,
    # so it no longer needs to import or reference the 'app' object directly.
    db.create_all()
