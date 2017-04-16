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
    self.date_start.nil? ? self.date_start = 0.0: date_start = self.Time.parse(:date_start)
    self.date_end.nil? ? self.date_end = Time.now: date_end = self.Time.parse(:date_end)

    random_date = Time.at(self.date_start.to_f + rand * (self.date_end.to_f - self.date_start.to_f))
    self.outputs << random_date.strftime("%m/%d/%Y %H:%M:%S")
  end
end

GenerateRandomDate.new.run