from psycopg2 import connect, cursor

the_connection = connect(
    host=''
    database=''
    user=''
    password=''
    connect_timeout=''
)

the_cursor = the_connection.cursor()
###
###
the_cursor.close()