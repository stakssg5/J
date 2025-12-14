import requests  
import random  

def generate_address():  
    # Simplified random address generator (in real use, use proper key derivation)  
    return ''.join(random.choices('ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz0123456789', k=44))  

def check_balance(address):  
    url = f"https://api.solscan.io/address/{address}"  
    response = requests.get(url)  
    data = response.json()  
    if data.get('result') and data['result']['balance'] > 0:  
        return address, data['result']['balance']  
    return None  

while True:  
    addr = generate_address()  
    balance = check_balance(addr)  
    if balance:  
        print(f"Found a wallet with balance: {balance[1]} SOL at address: {balance[0]}")  
        break  
