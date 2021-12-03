# frozen_string_literal: true

# Dir.glob("#{__dir__}/*.rb").sort.each do |file|
Dir.glob("#{__dir__}/*.rb").each do |file|
  require file
end
