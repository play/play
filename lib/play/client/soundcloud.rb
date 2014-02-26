module Play
  module Client
    module SoundCloud
      def soundcloud_client
        @soundcloud_client ||= ::SoundCloud.new(:client_id => Play.config['soundcloud']['client_id'])
      end
    end
  end
end
