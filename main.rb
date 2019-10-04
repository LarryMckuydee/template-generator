require_relative 'generator/all'
require 'active_support/all'

include Generator

command, *args = ARGV

dir = "/home/vagrant/simurgh"

if command == "scaffold"
    Generator::Laravel::Migration::generate(dir, args) 
    Generator::Laravel::Controller::generate(dir, args)
    Generator::Laravel::Model::generate(dir, args)
    Generator::Vue::Component::generate(dir, args)

elsif command == "mmc"
    Generator::Laravel::Migration::generate(dir, args) 
    Generator::Laravel::Controller::generate(dir, args)
    Generator::Laravel::Model::generate(dir, args)

elsif command == "test"
    
    Generator::Laravel::Migration::foo 
    Generator::Laravel::Controller::foo
    Generator::Laravel::Model::foo
    Generator::Vue::Component::foo
else
    puts "Option not recognize"
end
