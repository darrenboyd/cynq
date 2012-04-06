require "thor"

module Cynq
  class Command < Thor
    desc "foo", "Prints foo"
    def foo
      puts "foo"
    end
  end
end
