# # frozen_string_literal: true

# require_relative '../../helpers/spec_helper'
# require_relative '../../helpers/database_helper'
# require_relative '../../helpers/vcr_helper'

# require 'headless'
# require 'webdrivers/chromedriver'
# require 'watir'

# describe 'Acceptance Tests' do
#   before do
#     DatabaseHelper.wipe_database
#     # @headless = Headless.new
#     @browser = Watir::Browser.new

#     # options = Selenium::WebDriver::Chrome::Options.new
#     # options.add_argument('--headless')
#     # options.add_argument('--no-sandbox')
#     # options.add_argument('--disable-gpu')
#     # options.add_argument('--disable-dev-shm-usage')
#     # options.add_argument('--profile-directory=Default')
#     # options.add_argument('--user-data-dir=~/.config/google-chrome')

#     # @browser = Watir::Browser.new :chrome, options => options
#   end

#   after do
#     @browser.close
#     # @headless.destroy
#   end

#   describe 'Homepage' do
#     describe 'Visit Home page' do
#       it '(HAPPY) should not see firms if none created' do
#         # GIVEN: user is on the home page without any firms
#         @browser.goto homepage

#         # THEN: user should see basic headers, no firms and a welcome message
#         # _(@browser.h1(id: 'main_header').text).must_equal 'SECond'
#         _(@browser.text_field(id: 'firm-cik-input').present?).must_equal true
#         _(@browser.button(id: 'cik-submit').present?).must_equal true
#         _(@browser.table(id: 'firms-table').exists?).must_equal false

#         _(@browser.div(id: 'flash_bar_success').present?).must_equal true
#         _(@browser.div(id: 'flash_bar_success').text.downcase).must_include 'start'
#       end

#       it '(HAPPY) should not see firms they did not request' do
#         # GIVEN: a firm exists in the database but user has not requested it
#         firm = SECond::Edgar::FirmMapper.new.find(CIK)
#         SECond::Repository::For.entity(firm).create(firm)

#         # WHEN: user goes to the homepage
#         @browser.goto homepage

#         # THEN: they should not see any firms
#         _(@browser.table(id: 'firms-table').exists?).must_equal false
#       end
#     end

#     describe 'Add Firm' do
#       it '(HAPPY) should be able to request a firm' do
#         # GIVEN: user is on the home page without any firms
#         @browser.goto homepage

#         # WHEN: they add a firm URL and submit
#         good_cik = CIK
#         @browser.text_field(id: 'firm-cik-input').set(good_cik)
#         @browser.button(id: 'cik-submit').click

#         # THEN: they should find themselves on the project's page
#         @browser.url.include? 'firm'
#         @browser.url.include? good_cik
#       end

#       it '(BAD) should not be able to add an invalid firm cik' do
#         # GIVEN: user is on the home page without any firms
#         @browser.goto homepage

#         # WHEN: they request a firm with an invalid cik
#         bad_cik = 'foobar'
#         @browser.text_field(id: 'firm-cik-input').set(bad_cik)
#         @browser.button(id: 'cik-submit').click

#         # THEN: they should see a warning message
#         _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
#         _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'trouble' # 'invalid'
#       end

#       it '(SAD) should not be able to add valid but non-existent firm cik' do
#         # GIVEN: user is on the home page without any firms
#         @browser.goto homepage

#         # WHEN: they add a firm cik that is valid but non-existent
#         sad_cik = '0000000000'
#         @browser.text_field(id: 'firm-cik-input').set(sad_cik)
#         @browser.button(id: 'cik-submit').click

#         # THEN: they should see a warning message
#         _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
#         _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'trouble' # 'could not find'
#       end
#     end

#     describe 'Delete Firm' do
#       it '(HAPPY) should be able to delete a requested firm' do
#         # GIVEN: user has requested and created a single firm
#         @browser.goto homepage
#         good_cik = CIK
#         @browser.text_field(id: 'firm-cik-input').set(good_cik)
#         @browser.button(id: 'cik-submit').click

#         # WHEN: they revisit the homepage and delete the firm
#         @browser.goto homepage
#         @browser.button(id: 'firm[0].delete').click # not yet!

#         # THEN: they should not find any firms
#         _(@browser.table(id: 'firms-table').exists?).must_equal false
#       end
#     end
#   end

#   describe 'Firm Page' do
#     it '(HAPPY) should see firm content if firm exists' do
#       # GIVEN: a firm exists
#       firm = SECond::Edgar::FirmMapper.new.find(CIK)
#       SECond::Repository::For.entity(firm).create(firm)

#       # WHEN: user goes directly to the project page
#       @browser.goto "http://localhost:9000/firm/#{CIK}"

#       # THEN: they should see the firm details
#       _(@browser.h2.text).must_include FIRM_NAME

#       filing_columns = @browser.table(id: 'filings_table').thead.ths.select do |col|
#         col.attribute(:class).split.sort == %w[att filing]
#       end

#       _(filing_columns.count).must_equal 5

#       _(filing_columns.map(&:text).sort)
#         .must_equal ['Accession Number', 'Filing Date', 'Form Type', 'Reporting Date', 'Size']
#     end

#     #  it '(HAPPY) should be able to traverse to subfolders' do
#     #    project = SECond::Edgar::FirmMapper
#     #      .new(GITHUB_TOKEN)
#     #      .find(USERNAME, PROJECT_NAME)

#     #    SECond::Repository::For.entity(project).create(project)

#     #    @browser.goto "http://localhost:9000/project/#{USERNAME}/#{PROJECT_NAME}"

#     #    folder_rows = @browser.table(id: 'filings_table').trs.select do |row|
#     #      row.td(class: %w[folder name]).present?
#     #    end

#     #   views_folder = folder_rows.last.tds.find do |column|
#     #     column.link.href.include? 'views_objects'
#     #   end

#     #   views_folder.link.click

#     #   _(@browser.h2.text).must_include USERNAME
#     #   _(@browser.h2.text).must_include PROJECT_NAME

#     #   folder_rows = @browser.table(id: 'filings_table').trs.select do |row|
#     #     row.td(class: %w[folder name]).present?
#     #   end

#     #   filing_rows = @browser.table(id: 'filings_table').trs.select do |row|
#     #     row.td(class: %w[file name]).present?
#     #   end

#     #   _(folder_rows).must_be_empty
#     #   _(filing_rows.count).must_equal 5

#     #    '(BAD) should report error if subfolder does not exist' do
#     #   # GIVEN a project that exists
#     #   project = SECond::Edgar::FirmMapper
#     #     .new(GITHUB_TOKEN)
#     #     .find(USERNAME, PROJECT_NAME)

#     #   SECond::Repository::For.entity(project).create(project)

#     #   # WHEN user goes to a non-existent folder of the project
#     #   @browser.goto "http://localhost:9000/project/#{USERNAME}/#{PROJECT_NAME}/bad_folder"

#     #   # THEN: user should see a warning message
#     #   _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
#     #   _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'could not find'
#   end
# end
