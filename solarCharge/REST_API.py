#python implementation of REST web service

from flask import Flask, jsonify, abort, request, make_response, url_for

from ethjsonrpc import EthJsonRpc
import time
import datetime

c = EthJsonRpc('127.0.0.1', 8101)

contract_addr = "ADDRESS"
station_ID = [123]
balance = c.eth_getBalance(contract_addr)

print("Starting balanc = " + str(balance))

app = Flask(__name__, static_url_path="")

@app.route('/api/stationstate/<int:ID>', methods = ['GET'])
#curl -i http://localhost:5000/api/stationstate/123
def getStationState(id):
    result = c.call(contract_addr, 'getStationState(uint256)', [id], ['bool'])
    return jsonify(result)

@app.route('/api/stationstate/<string:email>', methods = ['GET'])
#curl -i http://localhost:5000/api/user/abc@gmail.com
def getUser(email):
    result = c.call(contract_addr, 'getUser(string)', [email], ['string', 'address', 'uint256', 'uint256'])
    return jsonify(result)

#curl -i -H "Content-Type: application/json" -X POST -d
# '{"email": "abc@gmail.com", "ID": 123, "duration":30 }'
# http://localhost:5000/api/activeStation
@app.route('/api/activeStation', methods = ['POST'])

def activeStation():
    if not request.json:
        abort(400)
    print(request.json)
    email = request.json['email']
    ID = request.json['ID']
    duration = request.json['duration']

    result = c.call_with_transaction(c.eth_coinbase(), contact_addr, 'activeStation(string, uint256)', [email, ID, duration] , gas = 300000)
    return jsonify(result)

if(__name__) == "__main__":
    app.run(debug= True, host = "0.0.0.0", port = 5000)





