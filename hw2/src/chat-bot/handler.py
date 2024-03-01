import json
import subprocess
# Import libraries for date/time and random selection
import datetime
import random
import re


def extract_text_in_quotes(text):
    pattern = r'"(.*?)"'
    matches = re.findall(pattern, text)
    return matches[0]


def handle(event):
    """Main function of the chatbot

    Args:
        event: A dictionary containing user input

    Returns:
        A JSON response with the chatbot's answer
    """

    # Extract user input
    # user_input = event["body"].lower()
    user_input = event.lower()

    # Define responses
    responses = {
        # Name
        "name": [
            "I'm Chintu, your friendly chatbot.",
            "You can call me Chintu, or the helpful assistant.",
            "Feel free to address me as Chintu."
        ],
        # Date and Time
        "date": [
            f"Today's date is {datetime.datetime.now().strftime('%Y-%m-%d')}.",
            f"The current time is {datetime.datetime.now().strftime('%H:%M:%S')}.",
            f"It's {datetime.datetime.now().strftime('%B %d, %Y')}. How can I assist you?"
        ],
        # Figlet generation
        "figlet": [
            "Generating a figlet for your request. Please wait..."
        ]
    }

    # Check for matching user input
    for key, value in responses.items():
        if key in user_input:
            # Return a random response from the list
            return json.dumps({"text": random.choice(value)})

    # Generate figlet for specific request
    if "figlet" in user_input:
        # Extract text for figlet generation
        # text = user_input.split("for", 1)[1].strip()
        text = extract_text_in_quotes(user_input)

        # Run figlet command (replace "faas-cli" with your actual figlet execution method)
        figlet_output = subprocess.run(["faas-cli", "invoke", "figlet", f"echo {text} |"], capture_output=True).stdout.decode("utf-8")

        # Return the generated figlet output (implementation not provided)
        return json.dumps({"text": f"Here is your figlet:\n {figlet_output}"})

    # Default response for unmatched input
    return json.dumps({"text": "I am still under development and learning. How can I help you today?"})

print(handle("name"))