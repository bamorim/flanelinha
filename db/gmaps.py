from math import ceil
import random
import requests
import json 

init_requests = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyCW2OA0MUeRUW7w4aGO1_p2sDOXyVLOMYo&keyword=bar&location=-22.9068,-43.1729&radius=320'

r = requests.get(init_requests)

json_data = r.json()
results = json_data['results'] 
print(len(results))
out = open('resultados.json', 'w')

for i in range(10):
    json_data = requests.get(
            init_requests +
            '&page_token=' +
            json_data['next_page_token']).json()
    results = results + json_data['results']

    try: 
        i = json_data['next_page_token']
    except: 
        break


for result in results:
    vagas = random.randint(1,100)
    especiais = ceil(vagas*0.07)
    
    to_add = {}
    to_add['name'] = result['vicinity'].partition(',')[0]
    to_add['spaces'] = vagas
    to_add['disabled_spaces'] = especiais
    to_add['latitude'] = result['geometry']['location']['lat']
    to_add['longitude'] = result['geometry']['location']['lng']

    json.dumps(to_add, separators=(',',':'))
    json.dump(to_add, out)

    if result != results[-1]:
        out.write(',')

out.write(']')
