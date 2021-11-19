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

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously seen projects
        session[:watching] ||= []

        # Load previously viewed projects
        firms = Repository::For.klass(Entity::Firm)
          .find_ciks(session[:watching])

        session[:watching] = firms.map(&:get_cik)

        if firms.none?
          flash.now[:notice] = 'Add a firm cik to get started'
        end

        viewable_firms = Views::FirmsList.new(firms)
        
        view 'home', locals: { firms: viewable_firms}
     end

      routing.on 'firm' do
        routing.is do
          # POST /firm/
          routing.post do
            firm_cik = routing.params['firm_cik']
            unless (firm_cik.size <= 10)
              flash[:error] = 'CIK exceeds 10-digit length'
              routing.redirect '/'
            end
            # routing.halt 400 unless (firm_cik.is_a? String) && (firm_cik.size <= 10)

            firm_cik = format('%010d', firm_cik.to_i)

            begin
              edgar_firm = Repository::For.klass(Entity::Firm).find_cik(firm_cik) 

              if edgar_firm.nil? == false
                session[:watching].insert(0, firm_cik).uniq!
                routing.redirect "firm/#{firm_cik}"
              end

            rescue StandardError => error
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end

            begin
              # Get filing from Firm
              firm = Edgar::FirmMapper
                .new
                .find(firm_cik)

              if firm.nil?
                flash[:error] = 'Firm not found'
                routing.redirect '/'
              end
              # Add filing to database
              Repository::For.entity(firm).create(firm)

            rescue StandardError => error
              flash[:error] = 'Having trouble creating firm'
              routing.redirect '/'
            end
            # Add new firm to watched set in cookies
            session[:watching].insert(0, firm_cik).uniq!

            # Redirect viewer to filing page
            routing.redirect "firm/#{firm_cik}"
          end
        end

        routing.on String do |firm_cik|
          # DELETE /project/{owner_name}/{project_name}
          routing.delete do
            session[:watching].delete(firm_cik)
            routing.redirect '/'
          end

          # GET /firm/firm_cik
          routing.get do
            # Get firm from database
            begin
              edgar_firm = Repository::For.klass(Entity::Firm)
                .find_cik(firm_cik)
            rescue StandardError => error
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end
              # Download 10-Ks from project information
              # api = Edgar::EdgarApi.new
              # firm_filings = edgar_firm.filings.select { |filing| filing.form_type.include? "10-K"}
              # firm_filings.each do |filing|
              # api.download_submission_url(firm_cik, filing.accession_number)
            begin
              firm_filings = FirmFiling.new(edgar_firm)
              firm_filings.download! unless firm_filings.exists_locally?
              # end
            rescue StandardError => error
              flash[:error] = 'Could not download filings'
              routing.redirect '/'
            end

            # Compile readability for firm specified by cik
            begin
              firm_rdb = Mapper::Readability
                .new.for_firm(firm_cik)
            rescue StandardError => error
              flash[:error] = 'Could not find that firm'
              routing.redirect '/'
            end
            firm = Views::Firm.new(edgar_firm)
            firm_rdbr = Views::FirmReadability.new(firm_rdb)
            # Show viewer the firm
            view 'firm', locals: { firm: firm, firm_rdb: firm_rdb }
          end
        end
      end
    end
  end
end
