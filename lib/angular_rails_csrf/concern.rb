module AngularRailsCsrf
  module Concern
    extend ActiveSupport::Concern

    included do
      before_filter :set_xsrf_token_cookie
    end

    def set_xsrf_token_cookie
      if protect_against_forgery?
        cookies['XSRF-TOKEN'] = {
          value: form_authenticity_token,
          secure: !Rails.env.dev?
        }
      end
    end

    def verified_request?
      if respond_to?(:valid_authenticity_token?, true)
        super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
      else
        super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
      end
    end
  end
end
