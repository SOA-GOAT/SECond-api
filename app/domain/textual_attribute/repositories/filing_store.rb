# frozen_string_literal: true

require 'fileutils'

module SECond
  module Repository
    # Collection of all local edgar firm filings download
    class FilingStore
      def self.all
        Dir.glob("#{App.config.TENKSTORE_PATH}/*")
      end

      def self.wipe
        all.each { |dir| FileUtils.rm_r(dir) }
      end
    end
  end
end
