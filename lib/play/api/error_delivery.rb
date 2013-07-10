module Play
  module Api
    module ErrorDelivery

      # Public: Delivers an error response for this request.
      #
      # status  - Fixnum HTTP status code of the error.
      # message - Optional String describing the error.
      #
      # Returns a String body to be used as the response of this request.
      def deliver_error(status, message=nil)
        message ||=
          case status
            when 404, :not_found            then "Not Found"
            when 400, :bad_request          then "Bad Request"
            when 401, :unauthorized         then "Requires authentication"
            when 409, :conflict             then "Conflict"
            when 422, :unprocessable_entity then "Validation Failed"
            when 301, :moved_permanently    then "Moved Permanently"
            else                                 "Server Error"
          end

          render :json => {:message => message}, :status => status
      end

    end
  end
end
