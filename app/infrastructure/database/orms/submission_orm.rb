# frozen_string_literal: true

require 'sequel'

module SECond
  module Database
    # Object Relational Mapper for Submission Entities
    class SubmissionOrm < Sequel::Model(:submissions)
      many_to_one :firm,
                  class: :'SECond::Database::SubmissionOrm'

    #   many_to_many :contributors,
    #                class: :'CodePraise::Database::MemberOrm',
    #                join_table: :projects_members,
    #                left_key: :project_id, right_key: :member_id

      plugin :timestamps, update_on_create: true
    end
  end
end