# frozen_string_literal: true

# Page object for home page
class HomePage
  include PageObject

  page_url SECond::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')

  # h1(:title_heading, id: 'main_header')
  text_field(:cik_input, id: 'firm-cik-input')
  button(:add_button, id: 'cik-submit')
  table(:firms_table, id: 'firms-table')

  indexed_property(
    :firms,
    [
      [:span, :cik,           { id: 'firm[%s].cik' }],
      [:span, :firm_name,     { id: 'firm[%s].name' }],
      [:span, :firm_tickers,  { id: 'firm[%s].tickers' }]
    ]
  )

  def first_firm
    firms[0]
  end

  def first_firm_row
    firms_table_element.trs[1]
  end

  def first_firm_delete
    first_firm_row.button(id: 'firm[0].delete').click
  end

  def first_firm_hover
    first_firm_row.hover
  end

  def first_firm_highlighted?
    first_firm_row.style('background-color').eql? 'rgba(0, 0, 0, 0.075)'
  end

  def num_firms
    firms_table_element.rows - 1
  end

  def add_new_firm(firm_cik)
    self.cik_input = firm_cik
    add_button
  end

  def listed_firm(firm)
    {
      firm_cik: firm.cik,
      name: firm.name,
      tickers: firm.tickers
    }
  end
end
