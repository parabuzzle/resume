# Michael L. Heijmans
# parabuzzle@gmail.com
# http://parabuzzle.github.io

require 'net/http'
require 'uri'

# load my objective
@objective = "To combine my knowledge and experience of high availability 
large-scale systems and technologies with my \"big picture\" thinking and 
outside-the-box mentality to build awesome maintainable applications with 
Ruby, Rails, and cloud services."

# url for formal resume
@formal_resume = "http://s3.amazonaws.com/mikeheymans/dltmp/resume-heijmans.pdf"
@dl_resume = false # need this to decide if I need to poke you at the end to download my resume :)

# Skills
@my_languages = ['RUBY', 'RAILS', 'Javascript', 'C', 'Objective-C', 'Bash']
@my_operating_systems = ['Red Hat Linux', 'Ubuntu Linux', 'FreeBSD']
@my_apps = ['Rails', 'Git', 'Github', 'Hadoop', 'HBase', 'MySQL', 'Apache', 'Postfix', 'Memcache', 'Tibco EMS', 'ActiveMQ', 'Subversion', 'Cassandra', 'Jenkins', 'Zookeeper']
@my_services = ['Heroku', 'Amazon S3', 'Amazon EC2', 'Amazon SQS', 'Amazon SES']
@my_protocols = ['TCP/IP', 'SMTP', 'IMAP', 'HTTP', 'FTP', 'NFS']
@my_misc_knowledge = ['REST', 'Cron', 'JSON', 'YAML', 'IRC', 'Test Driven Development', 'Agile', 'KanBan', 'Leadership', 'Mentorship']

# Job history
@my_jobs = ["Yahoo! - Senior Service Engineer for Y!Mail (May 12-Present)", 
        "Yahoo! - Service Engineering Manager for Y!Mail (Dec 10-May 12)",
        "Yahoo! - Senior Service Engineer for Y!Communites (June 08-Dec 10)",
        "techTribe Networks - Senior Operations Engineer (May 07-June 08)",
        "Neoteric Production Group - Systems Administrators (Feb 04-Dec 06)",
        "Fleeman, Anderson, and Bird Corp - Accounts Specialist (Nov 04- Nov 05)"]

# Open Source Projects    
@my_opensource_projects = {"Spunk - The Irc Bot Framework" => "http://parabuzzle.github.io/spunk", 
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

def main
  puts "Michael L. Heijmans"
  puts "421 Manchester Avenue"
  puts "Campbell, CA 95008"
  puts "Mobile: (415) 963-1565"
  puts "parabuzzle@gmail.com"
  puts "http://parabuzzle.github.io"
  puts "Principle Engineer"
  puts ""
  puts "###~~~OBJECTIVE~~~###"
  puts @objective
  puts ""
  puts "\n\nAvailable Commands:"
  puts ""
  @my_skills.keys.each do |sublist|
    puts " - #{sublist}"
  end
  puts " - profiles"
  puts " - open_source_projects"
  puts " - download_resume"
  puts " - listall"
  
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
    when /^exit|^quit/i
      raise Interrupt
    when /^(.+)/i
      puts output_array(fetch_skill_list($1))
      return true
  end # end case line
  return false
end
      

###############
# main routine#
###############

# On load, dump the main menu
main

# wrapped to catch interrupt
begin
  while line = gets
    # Get line from STDIN and parse it
    unless parse_line(line)
      # if there was nothing returned by the parse.. print the main menu
      main
    end
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


  