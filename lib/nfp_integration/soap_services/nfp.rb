require 'net/http'
require 'uri'
require 'nokogiri'
require 'nfp_integration/soap_services/base'
require 'nfp_integration/soap_services/nfp_authenticate_user'
require 'nfp_integration/soap_services/nfp_get_token_info'
require 'nfp_integration/soap_services/nfp_enrollment_data'
require 'nfp_integration/soap_services/nfp_payment_history'
require 'nfp_integration/soap_services/nfp_pdf_statement'
require 'nfp_integration/soap_services/nfp_statement_summary'
require 'nfp_integration/soap_services/nfp_current_statement_summary'


module NfpIntegration
  module SoapServices
    class Nfp

      include NfpIntegration::SoapServices::Base

      def initialize(customer_id)
        @customer_id = customer_id
        token
      end

      def  pdf_statement_info
        return nil if @token.blank?

        uri, request = build_request(NfpPdfStatement.new, {:token => token, :customer_id => @customer_id})

        response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
          http.request(request)
        end

        return parse_response(response)
      end

      def payment_history
        return nil if @token.blank?

        uri, request = build_request(NfpPaymentHistory.new, {:token => token, :customer_id => @customer_id})

        response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
          http.request(request)
        end

        return parse_response(response)
      end


      def statement_summary
        return nil if @token.blank?

        uri, request = build_request(NfpStatementSummary.new, {:token => token, :customer_id => @customer_id})
        response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
          http.request(request)
        end

        return parse_response(response)
      end

      def current_statement_summary
        return nil if @token.blank?

        uri, request = build_request(NfpCurrentStatementSummary.new, {:token => token, :customer_id => @customer_id})
        response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
          http.request(request)
        end

        return parse_response(response)
      end

      def payment_history
        return nil if @token.blank?

        uri, request = build_request(NfpPaymentHistory.new, {:token => token, :customer_id => @customer_id})
        response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
          http.request(request)
        end

        return parse_response(response)

      end

      # Get Enrollment Data from NFP
      def  enrollment_data
        return nil if @token.blank?

        uri, request = build_request(NfpEnrollmentData.new, {:token => token, :customer_id => @customer_id})
        response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
            http.request(request)
        end

        return parse_response(response)

      end

      # Gets local version of the token already retrieved
      def display_token
        @token.present? ? @token : nil
      end

      # Gets token info from NFP Server
      def get_token_info(token)

        uri, request = build_request(NfpGetTokenInfo.new, {:token => token})

        response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
          http.request(request)
        end

      end

      private

        def build_request(soap_object, parms = {})

          uri = URI.parse(::NfpIntegration.configuration.url)
          request = Net::HTTP::Post.new(uri)
          request.content_type = "text/xml;charset=UTF-8"
          request["Soapaction"] = soap_object.soap_action
          request.body = soap_object.body % parms

          return uri, request

        end

        def request_options(uri)
          {
            use_ssl: uri.scheme == "https",
          }
        end

        def parse_response(response)
          if response.code == "200"
            doc = Nokogiri::XML(response.body)
            return doc.remove_namespaces!
          end
          nil
        end

        def token

          return @token if defined? @token

          return nil if ::NfpIntegration.configuration.password == nil || ::NfpIntegration.configuration.user_id == nil

          uri, request = build_request(NfpAuthenticateUser.new, {:user => ::NfpIntegration.configuration.user_id, :password => ::NfpIntegration.configuration.password})

          response = Net::HTTP.start(uri.hostname, uri.port, request_options(uri)) do |http|
            http.request(request)
          end

          doc = Nokogiri::XML(response.body)
          doc.remove_namespaces!

          puts get_element_text(doc.xpath("//AuthToken"))
          @token_status = get_element_text(doc.xpath("//Success")) == "true" ? true : false
          @token = get_element_text(doc.xpath("//AuthToken"))

        end
    end
  end
end
