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
#     Remember to add other plugins to the "config.yml" file if you create them!
#
######
#
# Das ist ein einfaches TV Programm plugin, welches die aktuellen österreichischen
# Sendungen DVB-T Kanäle vorliest 
# Kann auch einfach für die deutschen Kanäle angepasst werden (siehe 3SAT) 
#
#      ladet das Plugin in der "config.yml" datei !
#
#######
## ##  WIE ES FUNKTIONIERT 
#
# sagt einfach einen Satz mit "TV" + "Programm" für eine komplette Ansage
# oder "Programm" + Sendername für eine spezifische Abfrage
# 
# 
# bei Fragen Twitter: @Muhkuh0815
# oder github.com/muhkuh0815/SiriProxy-TV
#
#
#### ToDo
#
# Zeitabfrage - wie lange die sendung noch läuft
# Primetime (20:15) Abfrage
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
 
# TV Programm
 
listen_for /(TV|spielt|spielers).*(Programm|Fernsehen)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        dob = Nokogiri::XML(eat("http://www.texxas.de/tv/spartensenderJetzt.xml"))
        dob.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if doc == NIL 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    elsif dob == NIL
   		say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')    
        dobs = dob.xpath('//title')            
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	if doss == "ORF 1"
        		orf1 = dos
        	elsif doss == "ORF 2"
        		orf2 = dos
        	elsif doss == "ORF 3"
        		orf3 = dos
        	elsif doss == "ATV: "
        		atv = dos
        	elsif doss == "ORF S"
        		orfs = dos
        	elsif doss == "Puls "
        		puls4 = dos
        	elsif doss == "Servu"
        		servus = dos
        	else
        	end
        	i += 1
        end
        i = 1
        while i < dobs.length
        	dos = dobs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	
        	if doss == "3SAT:"
        		sat = dos
        	else
        	end
        	i += 1
        end
            say orf1
            say orf2
            say orf3
            say atv
            say sat
            say puls4
            say servus
      		say orfs
        end    
    request_completed
end

# ORF 1 

listen_for /(spielt|TV|Programm).*(OR elf eins|Uherek elf eins|ORF eins|wo er F1|brav 1|horst eins|OF eins)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	if doss == "ORF 1"
        		orf1 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orf1
        end    
    request_completed
end

# ORF 2

listen_for /(spielt|TV|Programm).*(OR elf zwei|Uherek elf zwei|ORF zwei|wo er F2|brav 2|horst zwei|oder F2|OF zwei)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	
        	if doss == "ORF 2"
        		orf2 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orf2
        end    
    request_completed
end

# ORF 3

listen_for /(spielt|TV|Programm).*(OR elf drei|Uherek elf drei|ORF 3|wo er F3|brav 3|horst drei|hoher F3|oder F3|oder elf drei|OR F3|eures drei)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	if doss == "ORF 3"
        		orf3 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orf3
        end    
    request_completed
end

# ATV +

listen_for /(spielt|TV|Programm).*(ATV|A TV|ab TV|AUTEV|ARTE Frau|ART TV|ARTE TV)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	if doss == "ATV: "
        		atv = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say atv
        end    
    request_completed
end

# Puls 4

listen_for /(spiel|spieles|spielt|TV|Programm).*(Puls 4|Puls vier)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	if doss == "Puls "
        		puls4 = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say puls4
        end    
    request_completed
end

# Servus TV

listen_for /(spiel|spieles|spielt|TV|Programm).*(Servus|Servus TV)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	if doss == "Servu"
        		servus = dos
        	end
        	i += 1
        end
            say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say servus
        end    
    request_completed
end

# ORF SPORT PLUS

listen_for /(spiel|spieles|spielt|TV|Programm).*(Sport)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/oesterreichJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	
        	if doss == "ORF S"
        	orfs = dos
        	end
        	i += 1
        end
          say "Es spielt gerade auf", spoken: "Es spielt gerade auf,"       
            say orfs
        end    
    request_completed
end

# 3SAT

listen_for /(spiel|spieles|spielt|TV|Programm).*(3 Sat|drei SAT|dreisatz|3sat)/i do
    shaf = ""
    begin
        doc = Nokogiri::XML(eat("http://www.texxas.de/tv/spartensenderJetzt.xml"))
        doc.encoding = 'utf-8'
        rescue Timeout::Error
        print "Timeout-Error beim Lesen der Seite"
        shaf ="timeout"
        next
        rescue
        print "Lesefehler !"
        shaf ="timeout"
        next
    end
    if shaf =="timeout" 
        say "Es gab ein Problem beim Einlesen des Fernsehprogramms!"
    else
        docs = doc.xpath('//title')
        i = 1
        while i < docs.length
        	dos = docs[i].to_s
         	dos = dos.gsub(/<\/?[^>]*>/, "")
        	doss = dos[0,5]
        	if doss == "3SAT:"
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
