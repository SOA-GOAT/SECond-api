# frozen_string_literal: true

require 'roda'

module SECond
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :caching

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      response['Content-Type'] = 'application/json'
      # GET /
      routing.root do
        message = "SECond API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )
        print 'I am home'
        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'firm' do
          routing.on String do |firm_cik|
            # GET /firm/{firm_cik}
            routing.get do
              response.cache_control public: true, max_age: 300
              request_id = [request.env, request.path, Time.now.to_f].hash

              path_request = Request::FirmPath.new(
                firm_cik, request
              )
              puts 'working!!!'
              result = Service::InspectFirm.new.call(
                requested: path_request,
                request_id: request_id,
                config: App.config
              )

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::FirmTextualAttribute.new(
                result.value!.message
              ).to_json
            end

            # POST /firm/{firm_cik}
            routing.post do
              result = Service::AddFirm.new.call(
                firm_cik: firm_cik
              )

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::Firm.new(result.value!.message).to_json
            end
          end

          routing.is do
            # GET /firms?list={base64_json_array_of_firm_ciks}
            routing.get do
              list_req = Request::EncodedFirmList.new(routing.params)
              result = Service::ListFirms.new.call(list_request: list_req)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::FirmsList.new(result.value!.message).to_json
            end
          end
        end
      end
    end
  end
end
