require 'bigdecimal'
require 'date'
require 'set'

require 'dry-container'

require 'dry/data/version'
require 'dry/data/container'
require 'dry/data/type'
require 'dry/data/struct'
require 'dry/data/dsl'

module Dry
  module Data
    TYPE_SPEC_REGEX = %r[(.+)<(.+)>].freeze

    def self.container
      @container ||= Container.new
    end

    def self.register(name, type)
      container.register(name, type)
    end

    def self.[](name)
      result = name.match(TYPE_SPEC_REGEX)

      if result
        type_id, member_id = result[1..2]
        container[type_id].member(self[member_id])
      else
        container[name]
      end
    end

    def self.type(*args, &block)
      dsl = DSL.new(container)
      block ? yield(dsl) : registry[args.first]
    end
  end
end

require 'dry/data/types' # load built-in types
