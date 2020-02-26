from sqlalchemy import (
    insert,
    select,
    desc,
    func,
    cast,
    and_,
    or_,
    not_,
    update,
    delete,
    text,
    MetaData,
    Table,
    Column,
    Integer,
    Numeric,
    String,
    DateTime,
    ForeignKey,
    create_engine,
)

from sqlalchemy_core.db_config import db

engine = create_engine(db, pool_recycle=36000000, echo=False)

connection = engine.connect()

metadata = MetaData()


###############################################################################
#####                          Exceptions                                 #####
###############################################################################
