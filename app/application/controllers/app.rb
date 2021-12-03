# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module SECond
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css' # , js: 'table_row.js'

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    # rubocop:disable Metrics/BlockLength
    route do |routing|

      response['Content-Type'] = 'application/json'
      # GET /
      routing.root do
        message = "SECond API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'projects' do
          routing.on String, String do |owner_name, project_name|
            # GET /projects/{owner_name}/{project_name}[/folder_namepath/]
            routing.get do
              path_request = Request::ProjectPath.new(
                owner_name, project_name, request
              )

              result = Service::AppraiseProject.new.call(requested: path_request)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code

              Representer::ProjectFolderContributions.new(
                result.value!.message
              ).to_json
            end

            # POST /projects/{owner_name}/{project_name}
            routing.post do
              result = Service::AddProject.new.call(
                owner_name: owner_name, project_name: project_name
              )

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::Project.new(result.value!.message).to_json
            end
          end

          routing.is do
            # GET /projects?list={base64_json_array_of_project_fullnames}
            routing.get do
              list_req = Request::EncodedProjectList.new(routing.params)
              result = Service::ListProjects.new.call(list_request: list_req)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::ProjectsList.new(result.value!.message).to_json
            end
          end
        end
      end

      routing.on 'firm' do
        routing.is do
          # POST /firm/
          routing.post do
            cik_request = Forms::NewFirm.new.call(routing.params)
            firm_made = Service::AddFirm.new.call(cik_request)

            if firm_made.failure?
              flash[:error] = firm_made.failure
              routing.redirect '/'
            end

            firm = firm_made.value!
            session[:watching].insert(0, firm.cik).uniq!
            flash[:notice] = 'Firm added to your list'
            routing.redirect "firm/#{firm.formatted_cik}"
          end
        end

        routing.on String do |firm_cik|
          # DELETE /firm/{firm_cik}
          routing.delete do
            session[:watching].delete(firm_cik)
            routing.redirect '/'
          end

          # GET /firm/{firm_cik}
          routing.get do
            session[:watching] ||= []

            result = Service::InspectFirm.new.call(
              watched_list: session[:watching],
              requested: firm_cik
            )

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            inspected = result.value!
            firm = Views::Firm.new(inspected[:firm])
            firm_rdb = Views::FirmReadability.new(inspected[:firm_rdb])
            # Show viewer the firm
            view 'firm', locals: { firm: firm, firm_rdb: firm_rdb }
          end
        end
      end
    end
  end
end
