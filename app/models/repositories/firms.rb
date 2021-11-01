# frozen_string_literal: true

module SECond
    module Repository
      # Repository for Members
      class Firms
        def self.find_id(id)
          rebuild_entity Database::FirmOrm.first(id: id)
        end
  
        def self.find_name(name)
          rebuild_entity Database::FirmOrm.first(name: name)
        end
  
        def self.rebuild_entity(db_record)
          return nil unless db_record
  
          Entity::Firm.new(
            id:        db_record.id,
            cik: db_record.cik,
            name:  db_record.name,
            sic:     db_record.sic,
            sic_description: db_record.sic_description,
            tickers: db_record.tickers
          )
        end
  
        def self.rebuild_many(db_records)
          db_records.map do |db_firm|
            Firms.rebuild_entity(db_firm)
          end
        end
  
        def self.db_find_or_create(entity)
          Database::FirmOrm.find_or_create(entity.to_attr_hash)
        end
      end
    end
  end