## ChatBOT (openAI) in your terminal

#### Disclaimer
Ad hoc created chatBOT cli tool. \
Do you want standards, conventions and best practice? \
Then this is not for you :angry:

This project is still a 'WIP'\


#### Prerequisites
Ruby installed \
Api key from [OpenAI](https://platform.openai.com/overview)

#### Installation
```
gem install ask-ai
```

Configure your API key\

This is buggy and does not work as intended.\
For now Options 2 is the reliable way to setup the key.\

Option 1:
  run ``` ask-ai -h ``` this will let you paste the key in the terminal and the program will save it.\

Option 2:
  run ``` gem open ask-ai ``` find the file config/config.yml\
  where you need to put your OPENAI_API_KEY like so: \
OPENAI_API_KEY: \<key>

You can then use:
```
ask-ai [option] [input]
``` 

#### Usage

You can interact in two ways, 'normal' or 'conversation'. \
When you call ask-ai without flags like so:
```
ask-ai Can you give me a simple pasta recipe?
``` 
This is just a single question to the bot. \
When you call ask-ai with the conversation flag like so:
```
ask-ai -c I love pasta
```  
The bot will 'remember' that you like pasta and the next prompt could be:
```
ask-ai -c Give me a recipe of something i like
```
You will proboply get a pasta recipe because you said you love pasta. \
You can delete the conversation with:
```
ask-ai -d OR ask-ai -d "new question"
```

You can also start an interactive session, This is always a conversation. (the context for '-c' and '-i' is shared)\
```
ask-ai -i 
```



