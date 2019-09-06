require_relative "generator/laravel/migration"
require_relative "generator/laravel/controller"
require_relative "generator/laravel/model"
require_relative "generator/vue/component"

require 'active_support/all'

include Generator

command, *args = ARGV

dir = "/home/vagrant/simurgh"

if command=="scaffold"
    Generator::Laravel::Migration::generate(dir, args) 
    Generator::Laravel::Controller::generate(dir, args)
    Generator::Laravel::Model::generate(dir, args)
    Generator::Vue::Component::generate(dir, args)
end
