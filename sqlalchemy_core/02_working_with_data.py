from datetime import datetime

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

engine = create_engine(db, pool_recycle=3600, echo=False)

connection = engine.connect()

metadata = MetaData()
###############################################################################
#####                            Tables                                   #####
###############################################################################
cookies = Table(
    "cookies",
    metadata,
    Column("cookie_id", Integer(), primary_key=True),
    Column("cookie_name", String(50), index=True),
    Column("cookie_recipe_url", String(255)),
    Column("cookie_sku", String(55)),
    Column("quantity", Integer()),
    Column("unit_cost", Numeric(12, 2)),
)

users = Table(
    "users",
    metadata,
    Column("user_id", Integer(), primary_key=True),
    Column("customer_number", Integer(), autoincrement=True),
    Column("username", String(15), nullable=False, unique=True),
    Column("email_address", String(255), nullable=False),
    Column("phone", String(20), nullable=False),
    Column("password", String(25), nullable=False),
    Column("created_on", DateTime(), default=datetime.now),
    Column("updated_on", DateTime(), default=datetime.now, onupdate=datetime.now),
)
orders = Table(
    "orders",
    metadata,
    Column("order_id", Integer(), primary_key=True),
    Column("user_id", ForeignKey("users.user_id")),
)
line_items = Table(
    "line_items",
    metadata,
    Column("line_items_id", Integer(), primary_key=True),
    Column("order_id", ForeignKey("orders.order_id")),
    Column("cookie_id", ForeignKey("cookies.cookie_id")),
    Column("quantity", Integer()),
    Column("extended_cost", Numeric(12, 2)),
)

###############################################################################
#####                              insert                                 #####
###############################################################################
ins = cookies.insert().values(
    cookie_name="chocolate chip",
    cookie_recipe_url="http://some.aweso.me/cookie/recipe.html",
    cookie_sku="CC01",
    quantity="12",
    unit_cost="0.50",
)
print(str(ins))

t = ins.compile().params
print(t)
result = connection.execute(ins)
print(result.inserted_primary_key)

ins = insert(cookies).values(
    cookie_name="chocolate chip",
    cookie_recipe_url="http://some.aweso.me/cookie/recipe.html",
    cookie_sku="CC01",
    quantity="12",
    unit_cost="0.50",
)
ins = cookies.insert()
result = connection.execute(
    ins,
    cookie_name="dark chocolate chip",
    cookie_recipe_url="http://some.aweso.me/cookie/recipe_dark.html",
    cookie_sku="CC02",
    quantity="1",
    unit_cost="0.75",
)
result.inserted_primary_key
ins = cookies.insert()
inventory_list = [
    {
        "cookie_name": "peanut butter",
        "cookie_recipe_url": "http://some.aweso.me/cookie/peanut.html",
        "cookie_sku": "PB01",
        "quantity": "24",
        "unit_cost": "0.25",
    },
    {
        "cookie_name": "oatmeal raisin",
        "cookie_recipe_url": "http://some.okay.me/cookie/raisin.html",
        "cookie_sku": "EWW01",
        "quantity": "100",
        "unit_cost": "1.00",
    },
]
result = connection.execute(ins, inventory_list)

###############################################################################
#####                          select                                     #####
###############################################################################
s = select([cookies])
rp = connection.execute(s)
results = rp.fetchall()
print(results)

s = cookies.select()
rp = connection.execute(s)
results = rp.fetchall()
print(results)

###############################################################################
#####                           ResultProxy                               #####
###############################################################################
first_row = results[0]
print(first_row[1])
print(first_row.cookie_name)
print(first_row[cookies.c.cookie_name])

rp = connection.execute(s)
for record in rp:
    print(record.cookie_name)

###############################################################################
#####                     back to select and etc.                         #####
###############################################################################
s = select([cookies.c.cookie_name, cookies.c.quantity])
rp = connection.execute(s)
print(rp.keys())
result = rp.first()
print(result)

s = select([cookies.c.cookie_name, cookies.c.quantity])
s = s.order_by(cookies.c.quantity)
rp = connection.execute(s)
for cookie in rp:
    print("{} - {}".format(cookie.quantity, cookie.cookie_name))

s = select([cookies.c.cookie_name, cookies.c.quantity])
s = s.order_by(desc(cookies.c.quantity))
rp = connection.execute(s)
for cookie in rp:
    print("{} - {}".format(cookie.quantity, cookie.cookie_name))

# limit
s = select([cookies.c.cookie_name, cookies.c.quantity])
s = s.order_by(cookies.c.quantity)
s = s.limit(2)
rp = connection.execute(s)
print([result.cookie_name for result in rp])

# SUM(), COUNT()
s = select([func.sum(cookies.c.quantity)])
rp = connection.execute(s)
print(rp.scalar())

s = select([func.count(cookies.c.cookie_name)])
rp = connection.execute(s)
record = rp.first()
print(record.keys())
print(record.count_1)

# label the result
s = select([func.count(cookies.c.cookie_name).label("inventory_count")])
rp = connection.execute(s)
record = rp.first()
print(record.keys())
print(record.inventory_count)

# filtering
s = select([cookies]).where(cookies.c.cookie_name == "chocolate chip")
rp = connection.execute(s)
record = rp.first()
print(record.items())

s = select([cookies]).where(cookies.c.cookie_name == "chocolate chip")
rp = connection.execute(s)
record = rp.first()
print(record.items())

s = select([cookies]).where(cookies.c.quantity >= 3)
rp = connection.execute(s)
for e in rp:
    print(e.items())

s = select([cookies]).where(cookies.c.cookie_name.like("%chocolate%"))
rp = connection.execute(s)
for record in rp.fetchall():
    print(record.cookie_name)

###############################################################################
#####                          Operators                                  #####
###############################################################################
# string concat
s = select([cookies.c.cookie_name, "SKU-" + cookies.c.cookie_sku])
for row in connection.execute(s):
    print(row)

# cast
s = select(
    [
        cookies.c.cookie_name,
        cast((cookies.c.quantity * cookies.c.unit_cost), Numeric(12, 2)).label(
            "inv_cost"
        ),
    ]
)
for row in connection.execute(s):
    print("{} - {}".format(row.cookie_name, row.inv_cost))

# use conjunctions instead of boolean operators

###############################################################################
#####                        Conjunctions                                 #####
###############################################################################
s = select([cookies]).where(and_(cookies.c.quantity > 23, cookies.c.unit_cost < 0.40))
for row in connection.execute(s):
    print(row.cookie_name)

s = select([cookies]).where(
    or_(cookies.c.quantity.between(10, 50), cookies.c.cookie_name.contains("chip"))
)
for row in connection.execute(s):
    print(row.cookie_name)

###############################################################################
#####                          UPDATE                                     #####
###############################################################################
u = update(cookies).where(cookies.c.cookie_name == "chocolate chip")
u = u.values(quantity=(cookies.c.quantity + 120))
result = connection.execute(u)
print(result.rowcount)
s = select([cookies]).where(cookies.c.cookie_name == "chocolate chip")
result = connection.execute(s).first()
for key in result.keys():
    print("{:>20}: {}".format(key, result[key]))

###############################################################################
#####                        DELETE                                       #####
###############################################################################
u = delete(cookies).where(cookies.c.cookie_name == "dark chocolate chip")
result = connection.execute(u)
print(result.rowcount)

s = select([cookies]).where(cookies.c.cookie_name == "dark chocolate chip")
result = connection.execute(s).fetchall()
print(len(result))

###############################################################################
#####                       example                                       #####
###############################################################################
customer_list = [
    {
        "username": "cookiemon",
        "email_address": "mon@cookie.com",
        "phone": "111-111-1111",
        "password": "password",
    },
    {
        "username": "cakeeater",
        "email_address": "cakeeater@cake.com",
        "phone": "222-222-2222",
        "password": "password",
    },
    {
        "username": "pieguy",
        "email_address": "guy@pie.com",
        "phone": "333-333-3333",
        "password": "password",
    },
]

ins = users.insert()
result = connection.execute(ins, customer_list)

ins = insert(orders).values(user_id=1, order_id=1)
result = connection.execute(ins)

ins = insert(line_items)
order_items = [
    {"order_id": 1, "cookie_id": 1, "quantity": 2, "extended_cost": 1.00},
    {"order_id": 1, "cookie_id": 3, "quantity": 12, "extended_cost": 3.00},
]
result = connection.execute(ins, order_items)

ins = insert(orders).values(user_id=2, order_id=2)
result = connection.execute(ins)

ins = insert(line_items)
order_items = [
    {"order_id": 2, "cookie_id": 1, "quantity": 24, "extended_cost": 12.00},
    {"order_id": 2, "cookie_id": 4, "quantity": 6, "extended_cost": 6.00},
]
result = connection.execute(ins, order_items)

###############################################################################
#####                            Joins                                    #####
###############################################################################
columns = [
    orders.c.order_id,
    users.c.username,
    users.c.phone,
    cookies.c.cookie_name,
    line_items.c.quantity,
    line_items.c.extended_cost,
]
cookiemon_orders = select(columns)
cookiemon_orders = cookiemon_orders.select_from(
    orders.join(users).join(line_items).join(cookies)
).where(users.c.username == "cookiemon")
result = connection.execute(cookiemon_orders).fetchall()
for row in result:
    print(row)

columns = [users.c.username, func.count(orders.c.order_id)]
all_orders = select(columns)
all_orders = all_orders.select_from(users.outerjoin(orders))
all_orders = all_orders.group_by(users.c.username)
result = connection.execute(all_orders).fetchall()
for row in result:
    print(row)

###############################################################################
#####                         Aliases                                     #####
###############################################################################
employee_table = Table(
    "employee",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("manager", None, ForeignKey("employee.id")),
    Column("name", String(255)),
)
metadata.create_all(engine)


manager = employee_table.alias("mgr")
stmt = select(
    [employee_table.c.name],
    and_(employee_table.c.id == manager.c.id, manager.c.name == "Fred"),
)
print(stmt)

manager = employee_table.alias()
stmt = select(
    [employee_table.c.name],
    and_(employee_table.c.id == manager.c.id, manager.c.name == "Fred"),
)
print(stmt)

###############################################################################
#####                          Grouping                                   #####
###############################################################################
columns = [users.c.username, func.count(orders.c.order_id)]
all_orders = select(columns)
all_orders = all_orders.select_from(users.outerjoin(orders))
all_orders = all_orders.group_by(users.c.username)
result = connection.execute(all_orders).fetchall()
for row in result:
    print(row)


###############################################################################
#####                          Chaining                                   #####
###############################################################################
def get_orders_by_customer(cust_name):
    columns = [
        orders.c.order_id,
        users.c.username,
        users.c.phone,
        cookies.c.cookie_name,
        line_items.c.quantity,
        line_items.c.extended_cost,
    ]
    cust_orders = select(columns)
    cust_orders = cust_orders.select_from(
        users.join(orders).join(line_items).join(cookies)
    )
    cust_orders = cust_orders.where(users.c.username == cust_name)
    result = connection.execute(cust_orders).fetchall()
    return result


print(get_orders_by_customer("cakeeater"))


def get_orders_by_customer(cust_name, shipped=None, details=False):
    columns = [orders.c.order_id, users.c.username, users.c.phone]
    joins = users.join(orders)
    if details:
        columns.extend(
            [cookies.c.cookie_name, line_items.c.quantity, line_items.c.extended_cost]
        )
        joins = joins.join(line_items).join(cookies)
    cust_orders = select(columns)
    cust_orders = cust_orders.select_from(joins)
    cust_orders = cust_orders.where(users.c.username == cust_name)
    if shipped is not None:
        cust_orders = cust_orders.where(orders.c.shipped == shipped)
    result = connection.execute(cust_orders).fetchall()
    return result


print(get_orders_by_customer("cakeeater"))
print(get_orders_by_customer("cakeeater", details=True))
print(get_orders_by_customer("cakeeater", shipped=True))
print(get_orders_by_customer("cakeeater", shipped=False))
print(get_orders_by_customer("cakeeater", shipped=False, details=True))

###############################################################################
#####                          Raw queries                                #####
###############################################################################
result = connection.execute("select * from orders").fetchall()
print(result)

stmt = select([users]).where(text("username='cookiemon'"))
print(connection.execute(stmt).fetchall())

