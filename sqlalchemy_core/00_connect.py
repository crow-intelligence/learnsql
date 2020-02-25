from sqlalchemy import create_engine

# connection string
# db type, dialect, auth, location, port, dbname
user = "root"
password = "qwerty"
host = "localhost"
port = 3306
dbname = "sqlalchemy"

db = f"mysql+pymysql://{user}:{password}@{host}:{port}/{dbname}"
engine = create_engine(db, pool_recycle=10, echo=False)

connection = engine.connect()
