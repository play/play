
require 'rubygems'
require 'nokogiri'

# basically our goal is to do what Terminology.dump does...
# except that we start with a call to the sdef tool

module SDEFParser
  
  # direct quote from TerminologyParser::BigEndianParser
  # we need this in order to know what the reserved words are
  @@_reserved_keywords = {}
  ReservedKeywords.each { |name| @@_reserved_keywords[name] = nil }
  
  def self.xform(s)
    # turn AppleScript English-like term into rb-appscript style terminology
    # imitates TerminologyParser::BigEndianParser._name
    # might not do this perfectly, but we can refine later
    s = s.gsub(" ", "_").gsub("-", "_").gsub("/", "_").gsub("&", "and")
    # I've omitted some stuff; might not matter in practice
    # for example, if a character c is not legal (in LegalFirst and then in LegalRest),
    # he substitutes "0x#{c.unpack('HXh')}"; we could easily do this if necessary
    # special cases
    s += "_" if s.start_with?("AS_") or @@_reserved_keywords.has_key?(s) or s.start_with?("_")
    s
  end
  
  def self.hexify(s)
    # deal with sdef representation of nonprintables in codes
    # put into the form appscript expects
    s = [s[2..-1]].pack("H*") if s.length >= 10
    s
  end

  def self.makeModule(f, debugging=false)
    # f is expected to be the path to a scriptable application
    # TODO: how about a little error checking in case sdef doesn't work?
    # orig = `sdef '#{f}'`
    # use same underlying carbon call that sdef uses
    orig = AE.copy_scripting_definition(f)
    
    # anonymous module, to be returned when filled out
    result = Module.new
    
    # version and path, not sure what significance these have
    result.const_set(:Version, 1.1) # hard-coded into Terminology.dump_tables, so imitated here
    result.const_set(:Path, f)
    
    # prepare to parse XML
    doc = Nokogiri.parse(orig)
    
    # I could have made this code more "elegant" by collapsing steps into a repeated subroutine...
    # ...but I'd rather it be explicit and very plain
    # Nevertheless, the first three categories (classes, enumerators, properties) are absolutely identical
    
    # Classes ===================

    klasses = doc.search("class")
    klass_array = []
    klasses.each do |klass|
      klass_array << [xform(klass["name"]),hexify(klass["code"])]
    end
    # sort array on name
    klass_array.sort! {|a,b| a[0] <=> b[0]}
    klass_array.uniq!
    result.const_set(:Classes, klass_array)
    
    # Enumerators ================

    enums = doc.search("enumerator")
    enum_array = []
    enums.each do |enum|
      enum_array << [xform(enum["name"]),hexify(enum["code"])]
    end
    enum_array.sort! {|a,b| a[0] <=> b[0]}
    enum_array.uniq!
    result.const_set(:Enumerators, enum_array)
    
    # Properties =================

    props = doc.search("property")
    prop_array = []
    props.each do |prop|
      prop_array << [xform(prop["name"]),hexify(prop["code"])]
    end
    prop_array.sort! {|a,b| a[0] <=> b[0]}
    prop_array.uniq!
    result.const_set(:Properties, prop_array)
    
    # Elements ===============
    # Terminology.dump seems to use plurals in a slightly brute-force way
    # here, I'm only getting actual elements, and fetching their plurals from the classes
    # TODO: is that a problem? we'll cross that bridge when we come to it
    # (I can see why it might be, if the dictionary just forgot to list a class as an element)

    els = doc.search("element")
    el_array = []
    els.each do |el|
      # fetch corresponding property
      klas = doc.search("class[@name='#{el["type"]}']")
      # assume we caught at least one
      klas = klas[0]
      next unless klas and klas["plural"] # if we didn't get one or no plural, skip for now (TODO: ok?)
      el_array << [xform(klas["plural"]),hexify(klas["code"])]
    end
    el_array.sort! {|a,b| a[0] <=> b[0]}
    el_array.uniq!
    result.const_set(:Elements, el_array)
    
    
    # Commands ================
    # a little more elaborate because a command can have parameters
    
    coms = doc.search("command")
    com_array = []
    coms.each do |com|
      params = com.search("parameter")
      params_array = []
      params.each do |param|
        params_array << [xform(param["name"]),hexify(param["code"])]
      end
      com_array << [xform(com["name"]),hexify(com["code"]),params_array]
    end
    com_array.sort! {|a,b| a[0] <=> b[0]}
    com_array.uniq!
    result.const_set(:Commands, com_array)
    
    # output
    
    if debugging
      # instead of returning the module, return the text of the dumped module contents
      # we get Appscript itself to make the dump
      # thus the output can be easily diffed with the output from Terminology.dump
      tempfile = `mktemp -t terminologydump`
      tables = [klass_array, enum_array, prop_array, el_array, com_array]
      Terminology.dump_tables(tables, "DumpedTerminology", f, tempfile)
      return File.read(tempfile)
    end
    return result

  end

end

=begin and here's how to use it:
# require appscript (must be at least version 0.6.1)
# require this file -- we will error out if appscript has not been required

# start with path to scriptable application

f = "/Applications/iTunes.app"

# if what you have isn't a path, use the FindApp module to get it
# e.g.: f = FindApp.by_id('com.apple.itunes')

Tunes = SDEFParser.makeModule(f)
itu = Appscript.app("iTunes", Tunes)

# and we're off to the races
p itu.selection.get # or whatever
=end

# ignore this, just some tests I was using
if __FILE__ == $0
  # f = '/Users/mattleopard/Desktop/rb-appscript-0.6.1/src/lib'
  # $:.unshift f
  require 'pp'
  f = FindApp.by_id('com.apple.itunes')
  # s = SDEFParser.makeModule(f,true)
  # File.popen("bbedit", "w") {|io| io.write(s)}
  # exit
  result = SDEFParser.makeModule(f)
  result.constants.each do |con|
    puts
    puts con
    pp result.const_get(con)
  end
  itu = Appscript.app("iTunes", result)
  sel = itu.selection.get
  sel.each do |trk|
    puts trk.name.get
  end
  p itu.count(itu.playlists["Library"], :each => :track)
  p itu.playlists["Library"].tracks.count( :each => :item )
  #sel[0].play
end

