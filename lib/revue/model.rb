require 'active_model'

module Revue
  class Model
    class NeedsDefinitionError < NoMethodError; end

    include ActiveModel::Model
    extend Enumerable

    attr_accessor :id
    attr_reader :attributes

    def initialize(params = {})
      @attributes = params
      super
    end

    def self.create(params = {})
      model = new(params)
      model.save
      model
    end

    def self.find(by_id)
      model = new id: by_id
      return nil unless model.persisted?
      model.reload!
    end

    def self.each
      collection.each { |model| yield model }
    end

    def update_attributes(attributes = {})
      @attributes = attributes
      reload!
      save
    end

    def reload!
      writers.each do |writer, value|
        self.send writer, value if respond_to? writer
      end

      self
    end

    def save
      raise NeedsDefinitionError
    end

    def persisted?
      raise NeedsDefinitionError
    end

    private

    def writers
      attributes.reduce({}) do |setters_hash, (key, value)|
        setters_hash.merge "#{key}=" => value
      end
    end
  end
end
