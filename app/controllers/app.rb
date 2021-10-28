# frozen_string_literal: true

require 'roda'
require 'slim'

module SECond
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'firm' do
        routing.is do
          # POST /firm/
          routing.post do
            firm_cik = routing.params['cik']


            routing.halt 400 unless (firm_cik.is_a? Integer) &&
                                    (firm_cik.to_s.size <= 10)

            firm_cik = "%010d" % firm_cik
            routing.redirect "firm/#{firm_cik}"
          end
        end

        routing.on String do |firm_cik|
          # GET /firm/firm_cik
          routing.get do
            edgar_firm = Edgar::FirmMapper
              .new()
              .find(firm_cik)

            view 'firm', locals: { firm: edgar_firm }
          end
        end
      end
    end
  end
end
