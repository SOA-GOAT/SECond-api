# frozen_string_literal: true

folders = %w[submission edgar database]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
