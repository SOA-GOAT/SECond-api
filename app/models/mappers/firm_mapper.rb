# frozen_string_literal: false

module SECond
  module Edgar
    # Data Mapper: Edgar Submissions -> Firm entity
    class FirmMapper
      def initialize(gateway_class = Edgar::EdgarApi)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def find(cik)
        data = @gateway.submission_data(cik)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @gateway_class).build_entity # , @gateway_class NOT USED
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, gateway_class)
          # Argument: gateway_class NOT USED since only one mapper here
          @data = data
        end

        def build_entity
          SECond::Entity::Firm.new(
            sic: sic,
            sic_description: sic_description,
            name: name,
            tickers: tickers
          )
        end

        def sic
          @data['sic']
        end

        def sic_description
          @data['sicDescription']
        end

        def name
          @data['name']
        end

        def tickers
          @data['tickers']
        end
      end
    end
  end
end
