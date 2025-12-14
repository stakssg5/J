import requests

def scan_sol_address(address):
    url = "https://api.solana.com"
    payload = {"jsonrpc": "2.0", "id": 1, "method": "getBalance", "params": [address, "confirmed"]}
    response = requests.post(url, json=payload).json()
    
    if "result" in response and "value" in response["result"]:
        balance = response["result"]["value"] / 1e9  # Convert lamports to SOL
        if balance > 0:
            print(f"Found SOL balance: {balance} SOL at address {address}")
            return True
    print(f"No SOL balance found at address {address}")
    return False

# Example usage (replace with your target address or list)
target_address = "your-sol-address-here"
scan_sol_address(target_address)
