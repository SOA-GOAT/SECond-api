# frozen_string_literal: true

# Page object for firm page
class FirmPage
  include PageObject

  page_url SECond::App.config.APP_HOST +
           '/firm/<%=params[:firm_cik]%>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h2(:firm_title, id: 'firm-fullname')
  table(:firm_table, id: 'firm-table')
  table(:filings_table, id: 'filing-table')

  def filing_columns
    filings_table.thead.ths.select do |col|
      col.attribute(:class).split.sort == %w[att filing]
    end
  end
end
