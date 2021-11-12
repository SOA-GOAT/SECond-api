# frozen_string_literal: true

module SECond
    module Entity
      # Entity for file contributions
      class ParagraphReadability
  
        # WANTED_LANGUAGES = [
        #   Value::CodeLanguage::Ruby,
        #   Value::CodeLanguage::Python,
        #   Value::CodeLanguage::Javascript,
        #   Value::CodeLanguage::Css,
        #   Value::CodeLanguage::Html,
        #   Value::CodeLanguage::Markdown
        # ].freeze

        # sentences是paragraphs有幾句，number是第幾段
        attr_reader :sentences, :number
  
        def initialize(sentences:, number:)
          # @file_path = Value::FilePath.new(file_path)
          @sentences = sentences
          @number = number
        end
  
        # def language
        #   file_path.language
        # end
  
        def lengthy
        #   return Value::Lengthy.new if not_wanted
  
          @read_able ||=
            lines.each_with_object(Value::CreditShare.new) do |line, credit|
              credit.add_credit(line)
            end
        end
  
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
