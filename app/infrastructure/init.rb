# frozen_string_literal: true

folders = %w[edgar database submission cache messaging]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
