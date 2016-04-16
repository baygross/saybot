#### What is Saybot? Nay, who?
Saybot is a slackbot that will connect into airplay (on the local network of the host server) and speak aloud your message for you.  Useful for sending messages home to the apt, or creepy whispers at night.

You can choose vanity voices like `russian` or `whisper`, and insert arbitrary pauses a la `....`


#### License and thanks
MIT LICENSE

Big thanks to DBLOCK code at: 
https://github.com/dblock/slack-ruby-client


#### Example
![Demo](/demo.png?raw=true "Demo")

#### Misc Docker Commands
add this to .bash_profile so each shell can talk to daemon VM
  eval "$(docker-machine env default)"

check if daemon is running
>`docker-machine ls`

run daemon if not
>`docker-machine create --driver virtualbox default>`

status
>`docker images`
>`docker ps -a`
  
build
>`docker build -t saybot .`

stop and delete all containers
>`docker stop $(docker ps -a -q)`
>`docker rm $(docker ps -a -q)`

mount with volume for live code development
>`docker run --rm -it -e SLACK_TOKEN={KEY} -v {PWD_ABSOLUTE_PATH/app}:/app ga-bot`
