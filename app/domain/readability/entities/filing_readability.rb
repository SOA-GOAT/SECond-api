# frozen_string_literal: true

module SECond
    module Entity
      # Entity for file contributions
      class FilingReadability
        include Mixins::ReadabilityCalculator
  
        # WANTED_LANGUAGES = [
        #   Value::CodeLanguage::Ruby,
        #   Value::CodeLanguage::Python,
        #   Value::CodeLanguage::Javascript,
        #   Value::CodeLanguage::Css,
        #   Value::CodeLanguage::Html,
        #   Value::CodeLanguage::Markdown
        # ].freeze

        # paragraphs是filing有幾段
        attr_reader :paragraphs
  
        def initialize(paragraphs:)
          # @file_path = Value::FilePath.new(file_path)
          @paragraphs = paragraphs
        end
  
        # def language
        #   file_path.language
        # end
  
        # def credit_share
        #   return Value::CreditShare.new if not_wanted
  
        #   @credit_share ||=
        #     lines.each_with_object(Value::CreditShare.new) do |line, credit|
        #       credit.add_credit(line)
        #     end
        # end
  
        # def contributors
        #   credit_share.keys
        # end
  
        # def not_wanted
        #   !wanted
        # end
  
        # def wanted
        #   WANTED_LANGUAGES.include?(language)
        # end
      end
    end
  end
  