require_relative "generator/laravel/migration"
require_relative "generator/laravel/controller"
require_relative "generator/vue/component"

require 'active_support/all'

include Generator

command, *args = ARGV

if command=="scaffold"
    Generator::Laravel::Migration::generate(args) 
    Generator::Laravel::Controller::generate(args)
    Generator::Vue::Component::generate(args)
end
