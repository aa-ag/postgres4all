import requests
import json

queryurl = 'http://pg4e_86f9:*@es.py4e.com:9210/prefx/testindex/_search?pretty'
body=json.dumps( {"query": {"matchall": {}}} )
headers={'Content-type': 'application/json; charset=UTF-8'}

response = requests.post(
                queryurl, 
                headers=headers, 
                data=body
            )
print(response.status_code)
print(response.text)