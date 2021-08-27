#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_generator.rb'

class SuperuserRoleGenerator < StringGenerator
  def initialize
    super
    self.module_name = 'Default Superuser Role Generator'
  end

  def generate
    creds = File.readlines("#{WORDLISTS_DIR}/superuser_role")

    self.outputs << creds.sample.chomp
  end
end

SuperuserRoleGenerator.new.run
