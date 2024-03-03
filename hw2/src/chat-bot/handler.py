import json
import subprocess
# Import libraries for date/time and random selection
import datetime
import random
import re
import os
import requests
import time


def extract_text_in_quotes(text):
    pattern = r'"(.*?)"'
    matches = re.findall(pattern, text)
    return matches[0]

def extract_text_after_figlet(input_string):
    figlet_index = input_string.find("figlet ")
    if figlet_index != -1:
        return input_string[figlet_index + len("figlet"):].strip()
    else:
        return None


def handle(req):
    """Main function of the chatbot

    Args:
        req (str): request body

    Returns:
        A JSON response with the chatbot's answer
    """

    # Extract user input
    # user_input = event["body"].lower()
    user_input = req.lower()

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
            "Today's date is {}.".format(datetime.datetime.now().strftime('%Y-%m-%d'))

            # f"Today's date is {datetime.datetime.now().strftime('%Y-%m-%d')}.",
            # f"The current time is {datetime.datetime.now().strftime('%H:%M:%S')}.",
            # f"It's {datetime.datetime.now().strftime('%B %d, %Y')}. How can I assist you?"
        ],
        # Figlet generation
        "figlet": [
            "Generating a figlet for your request. Please wait..."
        ]
    }


    # Generate figlet for specific request
    if "figlet" in user_input:
        # Extract text for figlet generation
        # text = user_input.split("for", 1)[1].strip()
        # text = extract_text_in_quotes(user_input)
        text_extract = extract_text_after_figlet(user_input)
        # start = time.time()
        # output = os.popen("figlet " + text_extract).read()
        # # output = requests.post("http://127.0.0.1:8080/function/figlet", data=text_extract)
        # end = time.time()
        # print(end-start)
        # return output
        # return json.dumps({"text": "Here is your figlet:\n {}".format(output.text)})

        # Run figlet command (replace "faas-cli" with your actual figlet execution method)
        # figlet_output = subprocess.run(["faas-cli", "invoke", "figlet", f"echo {text} |"], capture_output=True).stdout.decode("utf-8")
        # figlet_output = subprocess.run(["echo " + text_extract + " | ", "faas-cli", "invoke", "figlet"], capture_output=True).stdout.decode("utf-8")
        figlet_output = subprocess.getoutput("echo " + text_extract + " | faas-cli invoke figlet")
        return subprocess.getoutput(figlet_output)
        
        

        # Run the command and capture its output
        return subprocess.run(command, shell=True, capture_output=True, text=True)
        
        # return figlet_output
        # output = os.popen("figlet hello").read()
        # return output
        # Return the generated figlet output (implementation not provided)
        # return json.dumps({"text": f"Here is your figlet:\n {figlet_output}"})
        return json.dumps({"text": "Here is your figlet:\n {}".format(figlet_output)})
    

    # Check for matching user input
    for key, value in responses.items():
        if key in user_input:
            # Return a random response from the list
            return json.dumps({"text": random.choice(value)})


    # Default response for unmatched input
    return json.dumps({"text": "I am still under development and learning. How can I help you today?"})

# print(handle("name"))