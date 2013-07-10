module Play
  module Api
    module JsonDelivery

      # Internal: Helper to deliver JSON.
      def deliver_json(status, object)
        render :json => object.to_hash, :status => status
      end

    end
  end
end
