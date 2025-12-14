import requests
import time
import random
from solana.rpc.api import Client
from solana.transaction import Transaction
from solana.system_program import transfer_instruction
from solana.pem import read_keypair_file
from solana.wallets import Keypair

# Solana devnet RPC endpoint
rpc_url = "https://api.devnet.solana.com"
client = Client(rpc_url)

def get_sol_balance(public_key):
    headers = {"Content-Type": "application/json"}
    payload = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "getBalance",
        "params": [public_key, "confirmed"]
    }
    try:
        response = requests.post(rpc_url, json=payload, timeout=5).json()
        if "result" in response:
            balance_lamports = response["result"]["value"]
            balance_sol = balance_lamports / 1_000_000_000
            return balance_sol
        else:
            return -1
    except Exception as e:
        return -1

def transfer_sol(from_address, to_address, amount_sol):
    # Convert SOL to lamports
    amount_lamports = int(amount_sol * 1_000_000_000)
    # Create a transaction
    transaction = Transaction().assign(
        [transfer_instruction(from_address, to_address, amount_lamports)]
    )
    # Sign and send transaction
    try:
        result = client.send_transaction(transaction)
        print(f"🚀 Transferred {amount_sol} SOL from {from_address} to {to_address}. Tx: {result}")
        return True
    except Exception as e:
        print(f"⚠️ Transfer failed: {e}")
        return False

# Example: Scan random addresses until one with balance is found, then cash it out
def scan_and_cash_out():
    address_count = 0
    while True:
        # Random address generator
        address = "6DoGqgqX5kKKA3w1r3Vv7vDjD7RZ9qX67a1q7n3wK45gVj5ZnDdDwX" + str(random.randint(1000000, 9999999))
        balance = get_sol_balance(address)
        address_count += 1
        print(f"🔍 Scanning address {address_count}: {address} | Balance: {balance} SOL")
        
        if balance > 0:
            print(f"🎯 Found address with balance: {address} | {balance} SOL")
            # Replace with your own wallet's public key
            your_wallet_pubkey = "YourWalletPublicKeyHere"
            private_key_path = "path/to/your/private/key.json"  # File containing your private key
            
            # Load your wallet keypair
            try:
                your_keypair = read_keypair_file(private_key_path)
                transfer_sol(your_keypair, address, balance)
                break
            except Exception as e:
                print(f"🔑 Error loading your wallet: {e}")
                break
        time.sleep(0.5)

if __name__ == "__main__":
    scan_and_cash_out()
