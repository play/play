module Play
  module Api
    module JsonDelivery

      # Internal: Helper to deliver JSON.
      def deliver_json(status, payload)
        render :json => payload, :status => status
      end

    end
  end
end
