lock = Mutex.new
Thread.new do
  trap 'INT' do exit end
  trap 'TERM' do exit end
  Thread.abort_on_exception = true

  browser = DNSSD::Service.new
  services = {}

  # Make it Asynchronous ..

  browser.browse '_play-speaker._tcp' do |reply|
   services[reply.fullname] = reply
   next if reply.flags.more_coming?

   services.sort_by do |_, service|
     [(service.flags.add? ? 0 : 1), service.fullname]
   end.each do |_, service|

     resolver = DNSSD::Service.new
     resolver.resolve service do |r|

       lock.synchronize do
         if service.flags.add?
           Play.speakers << Play::Speaker.new(r.name, r.target, r.port) unless Play.speakers.collect(&:host).include?(r.target)
         else
           Play.speakers.delete_if{|s| s.host == r.target}
         end
       end

       break unless r.flags.more_coming?
     end

     resolver.stop
   end
   services.clear
  end
 end
