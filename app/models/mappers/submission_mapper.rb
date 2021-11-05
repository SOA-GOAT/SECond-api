# frozen_string_literal: false

module SECond
  module Edgar
    # Data Mapper: Edgar Submission -> Submission entity
    class SubmissionMapper
      def initialize(gateway_class = Edgar::EdgarApi)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def load_several(cik)
        submission_hash = @gateway.submission_data(cik)
        keys = submission_hash.keys
        size = submission_hash['accessionNumber'].size
        size.each do |index|
          data = {cik: cik}
          keys.each { |key| data[key] = submission_hash[key][index] }
          SubmissionMapper.build_entity(data)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Submission.new(
            id: nil,
            cik: cik,
            accession_number: accessionNumber,
            form_type: form,
            filing_date: filingDate,
            reporting_date: reportDate,
            size: size 
          )
        end

        private

        def accession_number
          @data['accession_number']
        end

        def form_type
          @data['form_type']
        end

        def filing_date
          @data['filing_date']
        end

        def reporting_date
          @data['reporting_date']
        end

        def size
          @data['size']
        end
      end
    end
  end
end
