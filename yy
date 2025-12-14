import os  
import csv  

def extract_messages_to_csv(file_path, target_number, output_file):  
    if not os.path.exists(file_path):  
        print(f"😈 File '{file_path}' not found! 😈")  
        return  

    print(f"😈 Extracting messages containing number: {target_number} 😈")  
    with open(file_path, 'r') as file:  
        messages = file.readlines()  

    csv_data = []  
    found = False  
    for msg in messages:  
        if target_number in msg:  
            # Split message into sender, timestamp, text (assuming format: "Timestamp - Sender: Message")  
            parts = msg.split(" - ")  
            if len(parts) >= 2:  
                timestamp, rest = parts[0], parts[1]  
                sender, text = rest.split(": ", 1)  
                csv_data.append([timestamp, sender, text])  
                found = True  

    if csv_data:  
        with open(output_file, 'w', newline='') as csv_file:  
            writer = csv.writer(csv_file)  
            writer.writerow(["Timestamp", "Sender", "Message"])  # Header  
            writer.writerows(csv_data)  
        print(f"😈 CSV saved to '{output_file}' with {len(csv_data)} threaded messages. 😈")  
    else:  
        print(f"😈 No messages found with number: {target_number} 😈")  

# Example usage  
file_path = input("😈 Enter file path (e.g., messages.txt): ")  
target_number = input("😈 Enter the phone number to search: ")  
output_file = input("😈 Enter output CSV file name (e.g., extracted_messages.csv): ")  
extract_messages_to_csv(file_path, target_number, output_file)  
