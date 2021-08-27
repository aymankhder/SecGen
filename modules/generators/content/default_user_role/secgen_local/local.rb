#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_generator.rb'

class UserRoleGenerator < StringGenerator
  def initialize
    super
    self.module_name = 'Default User Role Generator'
  end

  def generate
    creds = File.readlines("#{WORDLISTS_DIR}/user_role")

    self.outputs << creds.sample.chomp
  end
end

UserRoleGenerator.new.run
