require 'net/http'
require 'uri'
require 'daemonize'


class Cour 
  def initialize()
    @valeur = []
    @cours = []
    @variations = []
    @ouverture = []
    @haut = []
    @bas = []
    @volume = []
    search()
  end
    
    attr_reader :valeur, :cours, :variations, :ouverture, :haut, :bas, :volume
    
  def search()
    src = []
    tmp = []

    for i in 0..2
      Net::HTTP.start( 'www.boursier.com', 80 ) do |http|
          src[i] =  http.get( '/vals/ALL/palmares/AZ-paris.asp?lt=%2A&pg='+ (i+1).to_s ).body
     end
      @cours[i] = src[i].scan(/<td class="value">([0-9]*,[0-9]*) &euro;<\/td>/)
      tmp[i] = src[i].to_s.scan(/<a href="\/vals\/.+.html">.*?<\/a><\/td>/)
      @valeur[i] = tmp[i].join.scan(/<a href=\".*?\">(.*?)<\/a>/) 
      @variations[i] = src[i].scan(/<td class="value var-.*?">(.*? %)<\/td>/)
      @ouverture[i] = src[i].scan(/\%<\/td><td class="value">(.*?)<\/td>/)
      @haut[i] = src[i].scan(/%<\/td><td class="value">.*?<\/td><td class="value">(.*?)<\/td>/)
      @bas[i] = src[i].scan(/%<\/td><td class="value">.*?<\/td><td class="value">.*?<\/td><td class="value">(.*?)<\/td>/)
      @volume[i] = src[i].scan(/%<\/td><td class="value">.*?<\/td><td class="value">.*?<\/td><td class="value">.*?<\/td><td class="value">(.*?)<\/td><\/tr>/s)
    end
    @valeur = (@valeur[0].join("|") + "|" + @valeur[1].join("|") + "|" + @valeur[2].join("|")).split("|") 
    @cours = (@cours[0].join("|") + "|" + @cours[1].join("|") + "|" + @cours[2].join("|")).split("|") 
    @ouverture = (@ouverture[0].join("|") + "|" + @ouverture[1].join("|") + "|" + @ouverture[2].join("|")).split("|") 
    @variations = (@variations[0].join("|") + "|" + @variations[1].join("|") + "|" + @variations[2].join("|")).split("|") 
    @haut = (@haut[0].join("|") + "|" + @haut[1].join("|") + "|" + @haut[2].join("|")).split("|") 
    @bas = (@bas[0].join("|") + "|" + @bas[1].join("|") + "|" + @bas[2].join("|")).split("|") 
    @volume = (@volume[0].join("|") + "|" + @volume[1].join("|") + "|" + @volume[2].join("|")).split("|")
  end
  
end