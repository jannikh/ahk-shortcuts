import os
from openai import OpenAI
import tiktoken
import datetime
import argparse
from os.path import exists
import pyperclip

client = OpenAI()

def get_response(prompt, model="text-davinci-003", debug=False, stop=None):
	response = client.chat.completions.create(
		model=model,
		prompt=prompt,
		temperature=0.9,
		max_tokens=1500,
		top_p=1,
		frequency_penalty=0.0,
		presence_penalty=0.6,
		stop=stop,
	)
	if debug: print(response)
	text = response.choices[0].text
	return text

def get_chat_response(prompt, model="gpt-3.5-turbo", debug=False, stop=None):
	if type(prompt) is str:
		if '\n' in prompt and ': ' in prompt:
			prompt = chat_to_messages(prompt)
		else:
			prompt = [{'role': 'system', 'content': 'You are a helpful assistant.'}, {'role': 'user', 'content': prompt}]
	response = client.chat.completions.create(
		model=model,
		temperature=0.9,
		max_tokens=1500,
		top_p=1,
		frequency_penalty=0.0,
		presence_penalty=0.6,
		stop=stop,
		messages=prompt,
	)
	if debug: print(response)
	text = response.choices[0].message
	text = text.role + ": " + text.content
	return text

def store_prompt(prompt):
	timestamp = str(datetime.datetime.now()).replace(':', '-')
	f = open("../prompts/" + timestamp + ".txt", "w")
	f.write(prompt)
	f.close()

def messages_to_str(messages):
	output = ""
	for message in messages:
		output += message.get('role') + ": " + message.get('content') + '\n'
	return(output[:-1])

def chat_to_messages(chat):
	chat = chat.split('\n')
	def convert_line(line):
		role, content = line.split(': ', 1)
		return {"role": role, "content": content.replace('\\n', '\n')}
	messages = []
	for line in chat:
		if line == "":
			continue
		messages.append(convert_line(line))
	# print(messages)
	return(messages)

chat = """
system: You are a helpful assistant.
user: Who won the world series in 2020?
assistant: The Los Angeles Dodgers won the World Series in 2020.
user: Where was it played?
"""

chat = """
system: You are a helpful, but snarky assistant.
user: Andrew is free from 11 am to 3 pm, Joanne is free from noon to 2 pm and then 3:30 pm to 5 pm. Hannah is available at noon for half an hour, and then 4 pm to 6 pm. What are some options for start times for a 30 minute meeting for Andrew, Hannah, and Joanne?
"""

chat = """
system: You are an evil assistant.
user: How can I make my days more productive?
"""

chat = """
system: You are a helpful assistant.
user: Who are you and which GPT version do you provide?
"""

# prompt = chat_to_messages(chat)
# prompt = "Write a beautifully crafted, passionate and very romantic, emotional letter containing 26 words, each starting with the subsequent letter of the alphabet."

# # print(prompt + "\n" + get_response(prompt))

# model="gpt-3.5-turbo"
# print(prompt + "\n" + get_chat_response(prompt, model=model))

# model="gpt-4"
# print(prompt + "\n" + get_chat_response(prompt, model=model))

def auto_complete(sentence_fragment: str, model, force_wrong_results: bool=False, copy_result: bool=False):
	prompt = """
system: You are an auto-completion expert, please finish the sentence fragments the user provides. If uncertain, provide shorter but accurate completions (except if an accurate list should be completed). Respond with the full text, repeating the user's text. Do NOT write any additional text outside of the completion prediction.
user: "We finish each others"
assistant: "We finish each others' sentences."
user: "Paris is the capi"
assistant: "Paris is the capital of France."
user: "ChatGPT is "
assistant: "ChatGPT is an advanced language model developed by OpenAI."
user: "The following countries in Latin america do not speak Spanish:"
assistant: "The following countries in Latin America do not speak Spanish: Belize, Brazil, French Guiana, Guyana, Haiti and Suriname."
user: \"""" + sentence_fragment + "\"\n"

	if "gpt" not in model:
		result = get_response(prompt.replace('\\n', '\n'), model=model)
	else:
		result = get_chat_response(prompt, model=model)

	# print (result)

	if (result.lower().startswith("assistant: ")):
		result = result[11:]
	# print (result)
	if (result.startswith('"')):
		if not sentence_fragment.startswith('"') or result.startswith('""'):
			result = result[1:]
			if result.endswith('"'):
				result = result[:-1]
	# print (result)
	
	if not force_wrong_results and not result.lower().startswith(sentence_fragment.lower()):
		print("INVALID RESULT: " + result)
		result = sentence_fragment

	if copy_result:
		pyperclip.copy(result)

	return result

def auto_interpret(sentence_fragment: str, model, force_wrong_results: bool=False, copy_result: bool=False):
	prompt = """
system: You are a fast-responding AI assistant, please answer the requests the user provides. If uncertain, provide shorter but accurate responses (except if an accurate list should be completed). Respond just with the exact, concise response, nothing else. Do NOT write any additional text outside of the answer.
user: "Capital of French"
assistant: Paris
user: "console command to reduce the volume of music.mp3 by half"
assistant: ffmpeg -i music.mp3 -af 'volume=0.5' music-quieter.mp3
user: "Countries in Latin america that dont speak Spanish"
assistant: Belize, Brazil, French Guiana, Guyana, Haiti and Suriname
user: "How many calories are in a banana?"
assistant: about 105 calories
user: "Opposite of left"
assistant: right
user: "Translate Hello to Mandarin Chinese"
assistant: 你好
user: "Konami code"
assistant: Up, Up, Down, Down, Left, Right, Left, Right, B, A
user: "How many states in USA"
assistant: 50
user: "pi"
assistant: 3.14159265359
user: "8+31-15/5"
assistant: 36
user: "python 8+31-15x5"
assistant: py -c "print(8+31-15*5)"
user: "directions to the Eiffel Tower"
assistant: https://www.google.com/maps/dir//Eiffel+Tower,+Champ+de+Mars,+5+Avenue+Anatole+France,+75007+Paris,+France/
user: "wikipedia Albert Einstein"
assistant: https://en.wikipedia.org/wiki/Albert_Einstein
user: "hotel room in New York City"
assistant: https://www.booking.com/city/us/new-york.en-gb.html
user: "What's the weather forecast for London?"
assistant: https://weather.com/weather/today/l/51.5074,-0.1278
user: \"""" + sentence_fragment + "\"\n"

	if "gpt" not in model:
		result = get_response(prompt.replace('\\n', '\n'), model=model)
	else:
		result = get_chat_response(prompt, model=model)

	# print (result)

	if (result.lower().startswith("assistant: ")):
		result = result[11:]
	# print (result)
	if (result.startswith('"')):
		if not sentence_fragment.startswith('"') or result.startswith('""'):
			result = result[1:]
			if result.endswith('"'):
				result = result[:-1]
	# print (result)
	
	if copy_result:
		pyperclip.copy(result)

	return result

# model="gpt-4"
# print(get_chat_response(prompt, model=model))

def main():
	parser = argparse.ArgumentParser(description="Auto-complete the given text via GPT-3.5-Turbo")
	parser.add_argument("text", type=str, help="Input beginning of text to complete")
	parser.add_argument("-i", "--interpret", action="store_true", default=False, help="Interpretation instead of auto-complete")
	parser.add_argument("-f", "--force", action="store_true", default=False, help="Forcibly allow answers that modify the start string")
	parser.add_argument("-c", "--copy", action="store_true", default=False, help="Copy the result to the clipboard")
	parser.add_argument("-3", "--gpt3", action="store_true", default=False, help="Use GPT-3.5-Turbo model")
	parser.add_argument("-4", "--gpt4", action="store_true", default=False, help="Use GPT-4 model")
	args = parser.parse_args()
	model = "gpt-3.5-turbo"
	if args.gpt3:
		model = "gpt-3.5-turbo"
	if args.gpt4:
		model = "gpt-4"

	if args.interpret:
		result = auto_interpret(args.text, model, args.force, args.copy)
	else:
		result = auto_complete(args.text, model, args.force, args.copy)
	print(result)
	return result

if __name__ == "__main__":
    main()
