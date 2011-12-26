# -*- encoding: utf-8 -*-
require 'cora'
require 'siri_objects'
require 'eat'
require 'nokogiri'
require 'timeout'


#######
# 
# This is a simple XML parsing Plugin for Austrian DVB-T Television Channels 
# and can easily be adoptet for German channels.
# sorry for the strange code - im just learning Ruby :-) 
#
#     Remember to add the plugin to the "./siriproxy/config.yml" file!
#
######
#
# Das ist ein einfaches TV Programm plugin, welches die aktuellen österreichischen
# Sendungen DVB-T Kanäle vorliest 
# Kann auch einfach für die deutschen Kanäle angepasst werden (siehe 3SAT) 
#
#      ladet das Plugin in der "./siriproxy/config.yml" datei !
#
########
## ## ##  WIE ES FUNKTIONIERT 
#
## # Was spielt es jetzt?
#
# sagt einfach einen Satz mit "TV" + "Programm" für eine komplette Ansage
# oder "Programm" + Sendername für eine spezifische Abfrage
#
## # Was spielt es Abends (20:15)
#
# "TV" + "Abend" oder "Primetime" für das komplette Hauptabendprogramm
# 
# 
# bei Fragen Twitter: @Muhkuh0815
# oder github.com/muhkuh0815/SiriProxy-TV
# Video Vorschau: http://www.youtube.com/watch?v=mTi9EC0M6Hw
#
#### ToDo
#
# Zeitabfrage - wie lange die sendung noch läuft
# bei spezifischer Abfrage - aktuelle + 2 folgende Sendungen
# Info Abfrage für Sendungsbeschreibung 
#
######

class SiriProxy::Plugin::TV < SiriProxy::Plugin
        
    def initialize(config)
        #if you have custom configuration options, process them here!
    end
    def doc
    end
    def docs
    end
    def dob
    end
 
 
 def tvprogramm(doc) # reading whats playing now - Austrian channels
    begin
    doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
    return doc
    rescue
     	doc = ""
    end
 end
 
 def tvprogrammabend(doc) # reading whats playing in the evening (20:15) - Austrian channels
 	begin
    doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreich.xml"))
    return doc
    rescue
     	doc = ""
    end
 end
 
 def tvprogrammsat(dob) # reading whats playing now - 3SAT
  	begin
    dob = Nokogiri::XML(eat("http://www.texxas.de/tv/spartensenderJetzt.xml"))
 	return dob
    rescue
    	dob = ""
    end
 end
 
 def tvprogrammsatabend(dob) # reading whats playing in the evening (20:15) - 3SAT
  	begin
    dob = Nokogiri::XML(eat("http://www.texxas.de/tv/spartensender.xml"))
 	return dob
    rescue
    	dob = ""
    end
 end
 
 def cleanup(doc)
 	doc = doc.gsub(/<\/?[^>]*>/, "")
 	return doc
 end
 
 def dosund(dos)
 	if dos["&amp;"]
 		dos["&amp;"] = "&"
    end
    return dos
 end
 
# TV Programm Abend - TV Programm Evening - all channels

listen_for /(TV|spielt|spielers).*(Crime Time|kleinteilen|Abend)/i do
doc = tvprogrammabend(doc)
dob = tvprogrammsatabend(dob)
    if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    elsif dob == NIL or dob == ""
   		say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
    	doc.encoding = 'utf-8'
    	dob.encoding = 'utf-8'
        docs = doc.xpath('//title')    
        dobs = dob.xpath('//title')            
        i = 1
        while i < docs.length 
        	dos = docs[i].to_s
         	dos = cleanup(dos)
         	doss = dos[0,5]
        	if doss == "ORF 1"
        		dos = dosund(dos)
        		orf1 = dos
        	elsif doss == "ORF 2"
        		dos = dosund(dos)
        		orf2 = dos
        	elsif doss == "ORF 3"
        		dos = dosund(dos)
           		orf3 = dos
        	elsif doss == "ATV: "
        		dos = dosund(dos)
        		atv = dos
        	elsif doss == "ORF S"
        		dos = dosund(dos)
        		orfs = dos
        	elsif doss == "Puls "
        		dos = dosund(dos)
        		puls4 = dos
        	elsif doss == "Servu"
        		dos = dosund(dos)
        		servus = dos
        	else
        	end
        	i += 1
        end
        i = 1
        while i < dobs.length
        	dos = dobs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	
        	if doss == "3SAT:"
        		dos = dosund(dos)
        		sat = dos
        	else
        	end
        	i += 1
        end
        	say "", spoken: "Programm für 20 Uhr 15"
            object = SiriAddViews.new
    		object.make_root(last_ref_id)
    		answer = SiriAnswer.new("TV Programm - 20:15", [
    	  		SiriAnswerLine.new(orf1), 
    	  		SiriAnswerLine.new(orf2), 
    	  		SiriAnswerLine.new(orf3), 
    	  		SiriAnswerLine.new(atv),
    	  		SiriAnswerLine.new(sat), 
    	  		SiriAnswerLine.new(puls4), 
    	  		SiriAnswerLine.new(servus),  
    	  		SiriAnswerLine.new(orfs)
    	  		])
    		object.views << SiriAnswerSnippet.new([answer])
    		send_object object
        end    
    request_completed
end

 
# TV Programm jetzt - TV Programm NOW all channels
 
listen_for /(TV|spielt|spielers).*(Programm|Fernsehen)/i do 
doc = tvprogramm(doc)
dob = tvprogrammsat(dob)
    if doc == NIL or doc == "" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    elsif dob == NIL or dob == ""
   		say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        doc.encoding = 'utf-8'
        dob.encoding = 'utf-8'
        docs = doc.xpath('//title')    
        dobs = dob.xpath('//title')            
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
         	doss = dos[0,5]
        	if doss == "ORF 1"
        		dos = dosund(dos)
        		orf1 = dos
        	elsif doss == "ORF 2"
        		dos = dosund(dos)
        		orf2 = dos
        	elsif doss == "ORF 3"
        		dos = dosund(dos)
           		orf3 = dos
        	elsif doss == "ATV: "
        		dos = dosund(dos)
        		atv = dos
        	elsif doss == "ORF S"
        		dos = dosund(dos)
        		orfs = dos
        	elsif doss == "Puls "
        		dos = dosund(dos)
        		puls4 = dos
        	elsif doss == "Servu"
        		dos = dosund(dos)
        		servus = dos
        	else
        	end
        	i += 1
        end
        i = 1
        while i < dobs.length
        	dos = dobs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	
        	if doss == "3SAT:"
        		dos = dosund(dos)
        		sat = dos
        	else
        	end
        	i += 1
        end
         	say "", spoken: "Es spielt gerade."
      		
			object = SiriAddViews.new
    		object.make_root(last_ref_id)
    		answer = SiriAnswer.new("TV Programm - aktuell", [
    	  		SiriAnswerLine.new(orf1), 
    	  		SiriAnswerLine.new(orf2), 
    	  		SiriAnswerLine.new(orf3), 
    	  		SiriAnswerLine.new(atv),
    	  		SiriAnswerLine.new(sat), 
    	  		SiriAnswerLine.new(puls4), 
    	  		SiriAnswerLine.new(servus),  
    	  		SiriAnswerLine.new(orfs)
    	  		])
    		object.views << SiriAnswerSnippet.new([answer])
    		send_object object
      		
        end    
    request_completed
end

# ORF 1 now

listen_for /(spielt|TV|Programm).*(OR elf eins|Uherek elf eins|ORF eins|wo er F1|brav 1|horst eins|OF eins)/i do
	doc = tvprogramm(doc)
    if doc == NIL or doc == "" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "ORF 1"
        		dos = dosund(dos)
        		orf1 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orf1
        end    
    request_completed
end

# ORF 2 now

listen_for /(spielt|TV|Programm).*(OR elf zwei|Uherek elf zwei|ORF zwei|wo er F2|brav 2|horst zwei|oder F2|OF zwei|oder elf zwei|Uhr auf zwei|Uherek zwei|Uherek F2|Rolf zwei|OR F2|auf zwei)/i do
	doc = tvprogramm(doc)
	if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	
        	if doss == "ORF 2"
        		dos = dosund(dos)
        		orf2 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orf2
        end    
    request_completed
end

# ORF 3 now

listen_for /(spielt|TV|Programm).*(OR elf drei|Uherek elf drei|ORF 3|wo er F3|brav 3|horst drei|hoher F3|oder F3|oder elf drei|OR F3|eures drei)/i do
    doc = tvprogramm(doc)
	if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "ORF 3"
        		dos = dosund(dos)
        		orf3 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orf3
        end    
    request_completed
end

# ATV + now

listen_for /(spielt|TV|Programm).*(ATV|A TV|ab TV|AUTEV|ARTE Frau|ART TV|ARTE TV)/i do
	doc = tvprogramm(doc)
	if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
    	doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "ATV: "
        		dos = dosund(dos)
        		atv = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say atv
        end    
    request_completed
end

# Puls 4 now

listen_for /(spiel|spieles|spielt|TV|Programm).*(Puls 4|Puls vier)/i do
	doc = tvprogramm(doc)
    if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
		doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "Puls "
        		dos = dosund(dos)
        		puls4 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say puls4
        end    
    request_completed
end

# Servus TV now

listen_for /(spiel|spieles|spielt|TV|Programm).*(Servus|Servus TV)/i do
	doc = tvprogramm(doc)
    if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
    	doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "Servu"
        		dos = dosund(dos)
        		servus = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say servus
        end    
    request_completed
end

# ORF SPORT PLUS now

listen_for /(spiel|spieles|spielt|TV|Programm).*(Sport)/i do
	doc = tvprogramm(doc)
    if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
    	doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	
        	if doss == "ORF S"
        		dos = dosund(dos)
        		orfs = dos
        	end
        	i += 1
        end
          say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orfs
        end    
    request_completed
end

# 3SAT now

listen_for /(spiel|spieles|spielt|TV|Programm).*(3 Sat|drei SAT|dreisatz|3sat)/i do
	doc = tvprogrammsat(dob)
	if doc == NIL or doc == ""
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        doc.encoding = 'utf-8'
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = cleanup(dos)
        	doss = dos[0,5]
        	if doss == "3SAT:"
        		dos = dosund(dos)
        		sat = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say sat
        end    
    request_completed
end

end
