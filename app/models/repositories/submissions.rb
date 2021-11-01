# frozen_string_literal: true

require_relative 'firms'

module SECond
  module Repository
    # Repository for Project Entities
    class Submissions
      def self.all
        Database::SubmissionOrm.all.map { |db_submission| rebuild_entity(db_submission) }
      end

      def self.find_firm_name(firm_name)
        # SELECT * FROM `projects` LEFT JOIN `members`
        # ON (`members`.`id` = `projects`.`owner_id`)
        # WHERE ((`username` = 'owner_name') AND (`name` = 'project_name'))
        db_submission = Database::SubmissionOrm
          .left_join(:firms, id: :firm_id)
          .where(name: firm_name)
          .first
        rebuild_entity(db_firm)
      end

      def self.find(entity)
        find_accession_number(entity.accession_number)
      end

      def self.find_id(id)
        db_record = Database::SubmissionOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_accession_number(accession_number)
        db_record = Database::SubmissionOrm.first(accession_number: accession_number)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Submission already exists' if find(entity)

        db_submission = PersistSubmission.new(entity).call
        rebuild_entity(db_submission)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Submission.new(
          db_record.to_hash.merge(
            firm: Submissions.rebuild_entity(db_record.firm),
          )
        )
      end

      # Helper class to persist project and its members to database
      class PersistSubmission
        def initialize(entity)
          @entity = entity
        end

        def create_submission
          Database::SubmissionOrm.create(@entity.to_attr_hash)
        end

        def call
          firm = Firms.db_find_or_create(@entity.firm)

          create_submission.tap do |db_submission|
            db_submission.update(firm: firm)

            # @entity.contributors.each do |contributor|
            #   db_project.add_contributor(Members.db_find_or_create(contributor))
            end
          end
        end
      end
    end
  end
end