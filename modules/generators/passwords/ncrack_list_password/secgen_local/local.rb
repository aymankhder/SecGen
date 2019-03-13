#!/usr/bin/ruby
require_relative '../../../../../lib/objects/local_string_generator.rb'

class NcrackPasswordGenerator < StringGenerator
  def initialize
    super
    self.module_name = 'nCrack Password List Generator'
  end

  def generate
    self.outputs << File.readlines("#{WORDLISTS_DIR}/ncrackpassword.lst").sample.chomp
  end
end

NcrackPasswordGenerator.new.run