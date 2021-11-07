# frozen_string_literal: true

require 'roda'
require 'slim'

module SECond
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :public, root: 'app/views/public'
    plugin :assets, path: 'app/views/assets',
                    css: 'style.css', js: 'table_row_click.js'
    plugin :halt

    route do |routing| # rubocop:disable Metrics/BlockLength
      routing.assets # load CSS
      routing.public

      # GET /
      routing.root do
        edgar_firm = Repository::For.klass(Entity::Firm).all
        view 'home', locals: { firm: edgar_firm }
      end

      routing.on 'firm' do
        routing.is do
          # POST /firm/
          routing.post do
            firm_cik = routing.params['firm_cik']

            routing.halt 400 unless (firm_cik.is_a? String) &&
                                    (firm_cik.size <= 10)

            firm_cik = format('%010d', firm_cik.to_i)

            # Get submission from Firm
            submission = Edgar::FirmMapper
              .new
              .find(firm_cik)

            # Add submission to database
            Repository::For.entity(submission).create(submission)

            # Redirect viewer to submission page
            routing.redirect "firm/#{firm_cik}"
          end
        end

        routing.on String do |firm_cik|
          # GET /firm/firm_cik
          routing.get do
            # Get project from database
            edgar_firm = Repository::For.klass(Entity::Firm)
              .find_cik(firm_cik)

            # Show viewer the firm
            view 'firm', locals: { firm: edgar_firm }
          end
        end
      end
    end
  end
end
