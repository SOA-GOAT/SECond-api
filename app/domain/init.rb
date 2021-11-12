# frozen_string_literal: true

folders = %w[filings readability]
folders.each do |folder|
  require_relative "#{folder}/init"
end