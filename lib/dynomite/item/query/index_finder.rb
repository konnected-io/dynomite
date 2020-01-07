module Dynomite::Item::Query
  class IndexFinder
    def initialize(source, args)
      @source, @args = source, args
    end

    # TODO: possible to hav multiple indexes with the same name
    def find(attribute_name)
      @source.indexes.find do |i|
        i.key_schema.find do |key|
          attribute_name.to_s == key.attribute_name
        end
      end
    end

    def args_hash
      @args.inject({}) do |result, hash|
        result.merge(hash)
      end
    end
  end
end
