#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_generator.rb'

class JtRPasswordGenerator < StringGenerator
  def initialize
    super
    self.module_name = 'JtR Password List Generator'
  end

  def generate
    self.outputs << File.readlines("#{WORDLISTS_DIR}/jtrpassword.lst").sample.chomp
  end
end

JtRPasswordGenerator.new.run