module Alipay
  module Notify
    module Wap
      def self.verify?(params)
        params = Utils.stringify_keys(params)
        partner = params.delete('partner')
        notify_id = params['notify_data'].scan(/\<notify_id\>(.*)\<\/notify_id\>/).flatten.first

        Sign::Wap.verify?(params) && Notify.verify_notify_id?(notify_id, partner)
      end
    end

    module App
      def self.verify?(params)
        params = Utils.stringify_keys(params)
        partner = params.delete('partner')
        Sign::App.verify?(params) && Notify.verify_notify_id?(params['notify_id'], partner)
      end
    end

    def self.verify?(params)
      params = Utils.stringify_keys(params)
      partner = params.delete('partner')
      Sign.verify?(params) && verify_notify_id?(params['notify_id'], partner)
    end

    private

    def self.verify_notify_id?(notify_id, partner)
      open("https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{"#{partner}"}&notify_id=#{CGI.escape(notify_id.to_s)}").read == 'true'
    end
  end
end
