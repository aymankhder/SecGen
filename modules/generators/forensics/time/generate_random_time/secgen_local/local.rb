#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_generator.rb'
require 'date'

class GenerateRandomDate < StringGenerator
  attr_accessor :date_start
  attr_accessor :date_end

  def initialize
    super
    self.module_name = 'Random date generator'
    self.date_start = ''
    self.date_end = ''
  end

  def generate
    self.date_start = 0.0 if self.date_start.nil?
    self.date_end = Time.now if self.date_end.nil?
    random_date = Time.at(date_start.to_f + rand * (date_end.to_f - date_start.to_f))
    self.outputs << random_date
  end
end

GenerateRandomDate.new.run