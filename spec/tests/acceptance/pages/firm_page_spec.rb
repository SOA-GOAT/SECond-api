describe 'Firm Page' do
  it '(HAPPY) should see firm content if firm exists' do
    # GIVEN: a firm exists
    firm = SECond::Edgar::FirmMapper.new.find(CIK)
    SECond::Repository::For.entity(firm).create(firm)

    # WHEN: user goes directly to the project page
    @browser.goto "http://localhost:9000/firm/#{CIK}"

    # THEN: they should see the firm details
    _(@browser.h2.text).must_include FIRM_NAME

    filing_columns = @browser.table(id: 'filings_table').thead.ths.select do |col|
      col.attribute(:class).split.sort == %w[att filing]
    end

    _(filing_columns.count).must_equal 5

    _(filing_columns.map(&:text).sort)
      .must_equal ['Accession Number', 'Filing Date', 'Form Type', 'Reporting Date', 'Size']
  end

  #  it '(HAPPY) should be able to traverse to subfolders' do
  #    project = SECond::Edgar::FirmMapper
  #      .new(GITHUB_TOKEN)
  #      .find(USERNAME, PROJECT_NAME)

  #    SECond::Repository::For.entity(project).create(project)

  #    @browser.goto "http://localhost:9000/project/#{USERNAME}/#{PROJECT_NAME}"

  #    folder_rows = @browser.table(id: 'filings_table').trs.select do |row|
  #      row.td(class: %w[folder name]).present?
  #    end

  #   views_folder = folder_rows.last.tds.find do |column|
  #     column.link.href.include? 'views_objects'
  #   end

  #   views_folder.link.click

  #   _(@browser.h2.text).must_include USERNAME
  #   _(@browser.h2.text).must_include PROJECT_NAME

  #   folder_rows = @browser.table(id: 'filings_table').trs.select do |row|
  #     row.td(class: %w[folder name]).present?
  #   end

  #   filing_rows = @browser.table(id: 'filings_table').trs.select do |row|
  #     row.td(class: %w[file name]).present?
  #   end

  #   _(folder_rows).must_be_empty
  #   _(filing_rows.count).must_equal 5

  #    '(BAD) should report error if subfolder does not exist' do
  #   # GIVEN a project that exists
  #   project = SECond::Edgar::FirmMapper
  #     .new(GITHUB_TOKEN)
  #     .find(USERNAME, PROJECT_NAME)

  #   SECond::Repository::For.entity(project).create(project)

  #   # WHEN user goes to a non-existent folder of the project
  #   @browser.goto "http://localhost:9000/project/#{USERNAME}/#{PROJECT_NAME}/bad_folder"

  #   # THEN: user should see a warning message
  #   _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
  #   _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'could not find'
end