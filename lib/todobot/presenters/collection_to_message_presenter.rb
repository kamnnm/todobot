module TodoBot
  class CollectionToMessagePresenter
    def initialize(collection)
      @collection = collection
    end

    def execute
      return '' unless collection

      collection.pluck(:name).map.with_index(1) { |name, i| "\/#{i}. #{name}" }.join("\n")
    end

    private

    attr_reader :collection
  end
end
