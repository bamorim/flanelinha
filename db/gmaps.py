from math import ceil
import random
import requests
import json 

init_requests = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyCW2OA0MUeRUW7w4aGO1_p2sDOXyVLOMYo&keyword=bar&location=-22.9068,-43.1729&radius=10000'

r = requests.get(init_requests)

json_data = r.json()
results = json_data['results'] 
out = open('parkings.json', 'w')

for page in range(9):
    json_data = requests.get(
            init_requests +
            '&next_page_token=' +
            json_data['next_page_token']).json()
    results = results + json_data['results']

    try: 
        i = json_data['next_page_token']
    except: 
        break

print len(results)

for result in results:
    vagas = random.randint(1,100)
    especiais = int(ceil(vagas*0.07))
    
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
