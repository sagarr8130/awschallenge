import json
from collections import Counter

def lambda_handler(event, context):
    mydict={}
    with open('challenge.json') as f:
        data = json.load(f)
    user_counter = Counter(item["eyeColor"] for item in data["users"])
    
    for i, (user, count) in enumerate(user_counter.items()):
        mydict[user]= count
    return {
        'statusCode': 200,
        'body': json.dumps(mydict)
    }
