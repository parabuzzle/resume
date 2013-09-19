# Michael L. Heijmans
# parabuzzle@gmail.com
# http://parabuzzle.github.io

require 'net/http'
require 'uri'
require 'base64'

# load my objective
@objective = "To combine my knowledge and experience of high availability 
large-scale systems and technologies with my \"big picture\" thinking and 
outside-the-box mentality to build awesome maintainable applications."

# url for formal resume
@formal_resume = "http://s3.amazonaws.com/mikeheymans/dltmp/resume-heijmans.pdf"
@dl_resume = false # need this to decide if I need to poke you at the end to download my resume :)

# Skills
@my_languages = ['RUBY', 'RAILS', 'Javascript', 'C', 'Objective-C', 'Bash']
@my_operating_systems = ['Red Hat Linux', 'Ubuntu Linux', 'FreeBSD']
@my_apps = ['Rails', 'Git', 'Github', 'Redis', 'rspec', 'Capybara', 'Guard', 'Hadoop', 'HBase', 'MySQL', 'Apache', 'Postfix', 'Memcache', 'Tibco EMS', 'ActiveMQ', 'Subversion', 'Cassandra', 'Jenkins', 'Zookeeper']
@my_services = ['Heroku', 'Amazon S3', 'Amazon EC2', 'Amazon SQS', 'Amazon SES', 'Redis', 'Amazon Cloudfront']
@my_protocols = ['TCP/IP', 'SMTP', 'IMAP', 'HTTP', 'FTP', 'NFS']
@my_misc_knowledge = ['REST', 'Cron', 'JSON', 'YAML', 'IRC', 'Test Driven Development', 'Agile', 'KanBan', 'Leadership', 'Mentorship', 'Nerdy Jokes']

# Job history
@my_jobs = ["Yahoo! - Senior Service Engineer for Yahoo Mail Metadata and Search (May 12-Present)", 
        "Yahoo! - Service Engineering Manager for Yahoo Mail Search (Dec 10-May 12)",
        "Yahoo! - Senior Service Engineer for Yahoo Communites (June 08-Dec 10)",
        "techTribe Networks - Senior Operations Engineer (May 07-June 08)",
        "Neoteric Production Group - Systems Administrators (Feb 04-Dec 06)",
        "Fleeman, Anderson, and Bird Corp - Accounts Specialist (Nov 04- Nov 05)"]

# Open Source Projects    
@my_opensource_projects = {"humanize_boolean - Adds humanize method to booleans" => "http://parabuzzle.github.io/humanize_boolean",
                          "Yelp4Rails - Adds activerecord type interaction for yelp v2 api" => "http://parabuzzle.github.io/yelp4rails",
                          "Credstore - A library for working with encrpyted strings in RSA" => "http://parabuzzle.github.io/credstore",
                          "Spunk - The Irc Bot Framework" => "http://parabuzzle.github.io/spunk", 
                          "Bender - The Irc Bot application" => "http://parabuzzle.github.io/bender",
                          "HypeText - Dirty little Ruby HTTP client" => "http://parabuzzle.github.io/hypetext",
                          "Pickle Podcast Webapp - The Rails app that runs my podcast site" => "http://github.com/parabuzzle/picklepodcast",
                          "Lifehelpr Rails Webapp" => "http://github.com/parabuzzle/lifehelpr", 
                          "Lookgit - Old Rails app that works like Github" => "http://github.com/parabuzzle/lookgit"}

# My online profiles                         
@my_profiles = {"LinkedIn"=>"http://www.linkedin.com/in/mheijmans", 
            "Portfolio"=>"http://parabuzzle.github.io", 
            "Github"=>"http://www.github.com/parabuzzle"}

# skills hash
@my_skills = {"languages" => @my_languages,
            "operating_systems" => @my_operating_systems,
            "applications" => @my_apps,
            "services" => @my_services,
            "protocols" => @my_protocols,
            "misc_knowledge" => @my_misc_knowledge,
            "job_history" => @my_jobs}
            
#links hash
@my_links = {"profiles" => @my_profiles,
            "open_source_projects" => @my_opensource_projects}
            
################
#helper methods#
################

def fetch_skill_list(sublist)
  # returns the array of skills in sublist
  if @my_skills[sublist]; return @my_skills[sublist]; else ["unknown skill list name #{sublist}"]; end
end

def fetch_formal_resume(filename)
  # downloads the resume pdf and saves it to filename
  uri = URI.parse @formal_resume
  begin
    Net::HTTP.start(uri.host) do |http|
        resp = http.get(uri.path)
        open(filename, "wb"){ |file| file.write(resp.body)}
    end
  rescue
    puts "error fetching resume"
    return false
  end
  return true
end

def output_array(ary)
  puts ' * ' + ary.join("\n * ")
end

def output_hash(hash)
  hash.each do |k,v|
    puts "#{v} :: #{k}"
  end
end

def listall
  @my_skills.each do |k,v|
    puts ""
    puts "###{k}##"
    v.each do |i|
      puts " * #{i}"
    end
  end
  puts ""
  puts "###Links###"
  @my_links.each do |k,v|
    puts ""
    puts "###{k}##"
    v.each do |name, url|
      puts " * #{url} :: #{name}"
    end
  end
end

def list_commands
  puts "\n\nAvailable Commands:"
  puts ""
  @my_skills.keys.each do |sublist|
    puts " - #{sublist}"
  end
  puts " - profiles"
  puts " - open_source_projects"
  #puts " - download_resume"
  puts " - listall"
  puts " - help"
  puts " - print majestic mustang"
  puts " - quit"
end

def main
  puts "Michael L. Heijmans"
  puts "421 Manchester Avenue"
  puts "Campbell, CA 95008"
  puts "Mobile: (415) 963-1565"
  puts "parabuzzle@gmail.com"
  puts "http://parabuzzle.github.io"
  puts "Principal Engineer"
  puts ""
  puts "###~~~OBJECTIVE~~~###"
  puts @objective
  puts ""
  list_commands
  
end

def parse_line(line)
  # parses the lines and out puts the proper data
  case line
    when /^profiles/i
      output_hash @my_links['profiles']
      return true
    when /^open source projects|^open_source_projects|^projects/i
      output_hash @my_links['open_source_projects']
      return true
    when /^options|^what can I do\??/i
      array = @my_skills.keys + @my_links.keys
      output_array array
      return true
    when /^download_resume/i
      filename = "./mike-heijmans.pdf"
      if fetch_formal_resume(filename)
        puts "saved to #{filename}"
        @dl_resume = true
        return true
      end
      return false
    when /^email/i
      puts "parabuzzle@gmail.com"
      return true
    when /^call|^phone/i
      puts "(415) 963-1565"
      return true
    when /^objective/i
      puts @objective
      return true
    when /^listall/i
      listall
      return true
    when /^print majestic mustang/i
      print_art
      return true
    when /^help/i
      list_commands
      return true
    when /^exit|^quit/i
      raise Interrupt
    when /^(.+)/i
      puts output_array(fetch_skill_list($1))
      return true
  end # end case line
  return false
end

def print_art
  print Base64.decode64("CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgYFQiLC5gLSwgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICAgICAgICAgICAgJzgsIDouIAogICAgICAgICAgICAg\nICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYCIiYG9vb29iLiJU\nLC4gCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\nICAgLC1gIi4pTzs4OmRvb2IuJy0uIAogICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICAgLC4uYCcuJycgLWRQKClkOE84WW84OiwuLmAsIAog\nICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC1vOGItICAgICAs\nLi4pZG9PTzg6JzpvOyBgWTguYCwgCiAgICAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAsLi5iby4sLi4uLi4pT09PODg4bycgOm9PLiAgIi4gIGAt\nLiAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAsICJgImQuLi4u\nODhPT09PTzhPODhvICA6TzhvOy4gICAgOzssYiAKICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICAgICxkT09PT08iIiIiIiIiIk84ODg4OG86ICA6Tzg4\nT28uOzpvODg4ZCAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICIi\nODg4T2IuLi4sLS0gOm84OE84OG86LiA6byciIiIiIiIiWThPUCAKICAgICAg\nICAgICAgICAgICAgICAgICAgICAgICAgIGQ4ODg4Li4uLi4sLi4gOm84T084\nODg6OiA6OiAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIiIgLmRP\nTzhib2AnJywsO084OE86TzhvOiA6OiwgCiAgICAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICxkZDgiLiAgLC0pZG84TzhvOiIiIjsgOjo6IAogICAg\nICAgICAgICAgICAgICAgICAgICAgICAgICAgICAsZGIoLiAgVCk4UDo4bzo6\nOjo6ICAgIDo6OiAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg\nLSIiLGAoO08iS2RPbzo6ICAgICAgICA6OjogCiAgICAgICAgICAgICAgICAg\nICAgICAgICAgICAgICAgICAgLEssJyIuZG9vOjo6JyAgICAgICAgOm86IAog\nICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAuZG9vOjo6IiIi\nOjogIDouICAgICdvOiAKICAgICAgICAsLi4gICAgICAgICAgICAuO29vb29v\nb28uLm86IiIiIiIgICAgIDo6Oy4gOjo7LiAgJ28uIAogICAsLCAiJyAgICBg\nIC4uICAgLmQ7bzoiIiInICAgICAgICAgICAgICAgICAgOjpvOjs6Om86OiAg\nOjsgCiAgIGQsICAgICAgICAgLCAuLm9vbzo6OyAgICAgICAgICAgICAgICAg\nICAgICA6Om9vOjs6Om8iJy46byAKICAsZCcuICAgICAgIDpPT09PTzhPbzo6\nIiAnLi4gLiAgICAgICAgICAgICAgIDo6bzhPb286OyAgO286IAogICdQIiAg\nIDsgIDsuT1BkODg4OE84Ojo7LiAnb09vbzouOy4uICAgICAgICAgOzpPODhP\nb286JyBPIicgCiAgLDg6ICAgbzo6b09gIDg4ODg4T09vOjo6ICBvOE84T286\nOjo7OyAgICAgLDs6b084OE9PbzsgICcgCiAsWVAgICw6Ojs6TzogIDg4ODg4\nOG86Ojo6ICA6ODg4OE9vbzo6Ojo6Ojo6Ojpvbzg4ODg4OG87LiAsIAogJyxk\nOiA6OztPOzogICA6ODg4ODg4OjpvOyAgOjg4ODg4ODhPb29vb29vb29vbzg4\nODg4ODg4T287ICwgCiBkUFk6ICA6bzhPICAgICBZTzg4ODhPOk86OyAgTzg4\nODg4ODg4ODhPT09PODg4IiIgWThvOk84OG87ICwgCiwnIE86ICAnb2JgICAg\nICAgIjg4ODg4ODhPbzs7bzg4ODg4ODg4ODg4ODgnIicgICAgIGA4T086LmBP\nT2IgLiAKJyAgWTogICw6bzogICAgICAgYDhPODg4ODhPT29vIiIiIiIiIiIi\nIiInICAgICAgICAgICBgT09vYmBZOGJgIAogICA6OiAgJztvOiAgICAgICAg\nYDhPODhvOm9Pb1AgICAgICAgICAgICAgICAgICAgICAgICBgOE9vIGBZTy4g\nCiAgIGA6ICAgT286ICAgICAgICAgYDg4OE86Om9QICAgICAgICAgICAgICAg\nICAgICAgICAgICA4OE8gIDpPWSAKICAgIDpvOyA4b1AgICAgICAgICA6ODg4\nbzo6UCAgICAgICAgICAgICAgICAgICAgICAgICAgIGRvOiAgOE86IAogICAs\nb29POjhPJyAgICAgICAsZDg4ODhvOk8nICAgICAgICAgICAgICAgICAgICAg\nICAgICBkT28gICA7Oi4gCiAgIDtPOG9kbycgICAgICAgIDg4ODg4TzpvJyAg\nICAgICAgICAgICAgICAgICAgICAgICAgZG86OiAgb28uOiAKICBkImApOE8n\nICAgICAgICAgIllPODhPbycgICAgICAgICAgICAgICAgICAgICAgICAgICI4\nTzogICBvOGInIAogJyctJ2AiICAgICAgICAgICAgZDpPOG9LICAtaHJyLSAg\nICAgICAgICAgICAgICAgICBkT09vJyAgOm8iOiAKICAgICAgICAgICAgICAg\nICAgIE86OG86Yi4gICAgICAgICAgICAgICAgICAgICAgICA6ODhvOiAgIGA4\nOiwgCiAgICAgICAgICAgICAgICAgICBgOE86OzdiLC4gICAgICAgICAgICAg\nICAgICAgICAgIGAiOCcgICAgIFk6IAogICAgICAgICAgICAgICAgICAgIGBZ\nTztgOGInIAogICAgICAgICAgICAgICAgICAgICBgT287IDg6LiAKICAgICAg\nICAgICAgICAgICAgICAgIGBPUCI4LmAgCiAgICAgICAgICAgICAgICAgICAg\nICAgOiAgWThQIAogICAgICAgICAgICAgICAgICAgICAgIGBvICBgLCAKICAg\nICAgICAgICAgICAgICAgICAgICAgWThib2QuIAogICAgICAgICAgICAgICAg\nICAgICAgICBgIiIiIicgCg==\n")
end    

###############
# main routine#
###############

# On load, dump the main menu
main
puts "-------"


# wrapped to catch interrupt
begin
  while line = gets
    # Get line from STDIN and parse it
    unless parse_line(line)
      # if there was nothing returned by the parse.. print the main menu
      main
    end
    puts "-------"
  end
rescue Interrupt
  # catch an interrupt (ctrl-c or 'exit')
  if @dl_resume
    # if you downloaded my resume already.. just exit
    exit 0
  end
  # Looks like my resume wasn't downloaded...
  puts "Thank you for taking the time to checkout my Ruby Resume."
  puts " - Would you like to download my formal resume? (yes/no)"
  while line = gets
    # check for response
    if line.match(/yes|y/i)
      filename = "./mike-heijmans.pdf"
      if fetch_formal_resume(filename)
        puts "saved to #{filename}"
      end
      exit 0
    elsif line.match(/no|n/i)
      # Looks like you chose not to download my resume :(
      puts "Thanks for your time anyway."
      exit 1 # you get an error... because you didn't download my resume
    else
      # unrecognized response... print the question again
      puts " - Would you like to download my formal resume? (yes/no)"
    end
  end
  exit 0
end


  
