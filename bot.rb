require 'slack-ruby-client'

# overide hash-keys to become methods for cleaner calls
class Hash
  def method_missing(m)
    key = m.to_s
    return self[key] if self.has_key? key
    super
  end
end

## Initial load and setup
def init
  
  # Setup Slack
  Slack.configure do |config|
    config.token = ENV['SLACK_TOKEN'] || ARGV[0]
    if not config.token
      puts('Missing ENV[SLACK_TOKEN]! Exiting program')
      exit
    end
  end
  @client = Slack::RealTime::Client.new
  @client.on :hello do
     puts("Connected '#{@client.self['name']}' to '#{@client.team['name']}' team at https://#{@client.team['domain']}.slack.com.")
  end

  # Setup message hooks
  messageHook()
  
  # Cleanup hooks
  @client.on :close do |_data|
    puts 'Connection closing, exiting.'
    EM.stop
  end
  @client.on :closed do |_data|
    puts 'Connection has been disconnected.'
  end

  # Run this bad boy
  @client.start!
  
end

# Message hook 
def messageHook
  @client.on :message do |data|
    puts data

    case data.text
      
    when 'hi saybot' then
      @client.message channel: data.channel, text:  "Hi <@#{data.user}>  💁"
    when 'dance saybot' then
      @client.message channel: data.channel, text:  "👯👯👯👯👯👯"
    when 'saybot help', 'help saybot' then
      @client.message channel: data.channel, text:  "Hey there! Thanks for using saybot 🙌\n\n \
*Try these commands:*\n \
saybot hello world\n \
saybot russian hello citizens\n \
saybot whisper hey ... david ... you awake?"
      
    when /^saybot\ /
      msg = data.text.slice(7..-1)
      
      # sanitize
      msg = msg.gsub!(/[^0-9A-Za-z \.]/, '')
      
      # now build out command
      cmd = "say -a AirPlay "
      
      if msg.split.first == "whisper"
        cmd += "-v Whisper "
        msg = msg.split[1..-1].join(" ")
      end
        
      if msg.split.first == "russian"
        cmd += "-v Yuri "
        msg = msg.split[1..-1].join(" ")
      end
      
      # Boom, regex.  Replace "..." with a one second pause.  Any further dot indicates +n seconds
      msg.sub (/(\.){3,}/) {|dots| "[[slnc #{(dots.length-2)*1000}]]" }
      
      cmd += msg
      cmd += " [[slnc 5000]]"  # final pause to fix buffer from closing early
  
      # run it
      system(cmd)
      
    end
  
  end
end

init