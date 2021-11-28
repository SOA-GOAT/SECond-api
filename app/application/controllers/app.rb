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

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        # Get cookie viewer's previously seen firms
        session[:watching] ||= []

        result = Service::ListFirms.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_firms = []
        else
          firms = result.value!
          flash.now[:notice] = 'Add a firm cik to get started' if firms.none?
          session[:watching] = firms.map(&:formatted_cik)
          viewable_firms = Views::FirmsList.new(firms)
        end

        view 'home', locals: { firms: viewable_firms }
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