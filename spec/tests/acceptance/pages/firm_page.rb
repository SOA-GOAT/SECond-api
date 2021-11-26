# frozen_string_literal: true

# Page object for firm page
class FirmPage
  include PageObject

  page_url SECond::App.config.APP_HOST +
           '/firm/<%=params[:cik]%>'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  h2(:firm_title, id: 'firm_fullname')
  table(:firm_table, id: 'firm_table')
  table(:filing_table, id: 'filing_table')

  def filing_columns
    filing_table_element.thead.ths.select do |col|
      col.attribute(:class).split.sort == %w[att filing]
    end
  end
end
