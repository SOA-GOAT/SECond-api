# frozen_string_literal: true

folders = %w[firms readability]
folders.each do |folder|
  require_relative "#{folder}/init"
end
