## ChatBOT (openAI) in your terminal

#### Disclaimer
Ad hoc created chatBOT cli tool. \
Do you want standards, conventions and best practice? \
Then this is not for you :angry:

This project is still a 'WIP'

#### Prerequisites
Ruby installed \
Api key from [OpenAI](https://platform.openai.com/overview)

#### Installation
Clone this repo and run:
```
ruby terminal_chat/lib/main.rb --install
```
This will install dependencies and create a config.yml where you need to put your OPENAI_API_KEY like so: \
OPENAI_API_KEY: \<key>

As of now you need to create a "bash" function that collect the args and runs the main file:
(this is from my bashrc)

```
gpt () { 
  for i in "$*"; do <path_to_main.rb> "$i"; done; 
}
```
You can then use:
```
gpt [option] [input]
``` 

#### Usage

You can interact in two ways, 'normal' or 'conversation'. \
When you call gpt without flags like so:
```
gpt Can you give me a simple pasta recipe?
``` 
This is just a single question to the bot. \
When you call gpt with the conversation flag like so:
```
gpt -c I love pasta
```  
The bot will 'remember' that you like pasta and the next prompt could be:
```
gpt -c Give me a recipe of something i like
```
You will proboply get a pasta recipe because you said you love pasta. \
You can delete the conversation with:
```
gpt -d``` or ```gpt -d new question
```

