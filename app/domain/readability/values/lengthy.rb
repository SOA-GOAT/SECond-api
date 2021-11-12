# frozen_string_literal: true

module SECond
  module Value
    # Value of credits shared by contributors for file, files, or folder
    class Lengthy < SimpleDelegator
      # rubocop:disable Style/RedundantSelf
      def initialize
         super(Types::HashedIntegers.new)
      end

      def add_readable(sentence)
        self[sentence] += sentence.readability
      end

      # def +(other)
      #   (self.contributors + other.contributors).uniq
      #     .each_with_object(Value::CreditShare.new) do |contributor, total|
      #       total[contributor] = self[contributor] + other[contributor]
      #     end
      # end

      # def by_email(email)
      #   contributor = self.select do |contrib, _|
      #     contrib.email == email
      #   end.keys.first

      #   by_contributor(contributor)
      # end

      # def by_contributor(contributor)
      #   self[contributor]
      # end

      # def contributors
      #   self.keys
      # end
      # rubocop:enable Style/RedundantSelf
    end
  end
end