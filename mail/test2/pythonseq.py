import psycopg2
import hidden

# Load the secrets
secrets = hidden.secrets()

conn = psycopg2.connect(host=secrets['host'],
        port=secrets['port'],
        database=secrets['database'], 
        user=secrets['user'], 
        password=secrets['pass'], 
        connect_timeout=3)

cur = conn.cursor()

sql = 'DROP TABLE IF EXISTS pythonseq CASCADE;'
print(sql)
cur.execute(sql)

sql = 'CREATE TABLE pythonseq (iter INTEGER, val INTEGER);'
print(sql)
cur.execute(sql)

conn.commit() # Flush it all to the DB server

value = 717744
for i in range(300) :
    print(i+1, value)
    sql = f'INSERT INTO pythonseq (iter,val) VALUES ({i+1},{value});'
    value = int((value * 22) / 7) % 1000000
    cur.execute(sql)

conn.commit()
cur.close()

