# frozen_string_literal: true

require 'roda'
require 'yaml'

module SECond
  # Configuration for the App
  class App < Roda
    # CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
  end
end
