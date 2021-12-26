# frozen_string_literal: true

module EdgarDownload
  # Infrastructure to download while yielding progress
  module DownloadMonitor
    DOWNLOAD_PROGRESS = {
      'STARTED'     => 15,
      'Downloading' => 30,
      'remote'      => 70,
      'Receiving'   => 85,
      'Resolving'   => 95,
      'Checking'    => 100,
      'FINISHED'    => 100
    }.freeze

    def self.starting_percent
      DOWNLOAD_PROGRESS['STARTED'].to_s
    end

    def self.finished_percent
      DOWNLOAD_PROGRESS['FINISHED'].to_s
    end

    def self.progress(line)
      DOWNLOAD_PROGRESS[first_word_of(line)].to_s
    end

    def self.percent(stage)
      DOWNLOAD_PROGRESS[stage].to_s
    end

    def self.first_word_of(line)
      line.match(/^[A-Za-z]+/).to_s
    end
  end
end
