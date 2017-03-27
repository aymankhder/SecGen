#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_generator.rb'
require 'date'

class UrlGenerator < StringGenerator
  def initialize
    super
    self.module_name = 'Url generator'
    self.number_of_generic_urls = '10'
    self.generic_urls_start_time = '3rd july 2017'
    self.number_of_cybercrime_urls = ''
    self.cybercrime_urls_start_time = ''
  end

  def generate


    urls = Hash.new

    # number_of_generic_urls = 10
    # generic_urls_start_time = '3rd july 2017 15:16:20'
    # generic_urls_length_time = '2 days 1 hour 10 seconds'
    # ROOT_DIR = File.expand_path('../../../../../../../',__FILE__)
    # URLLISTS_DIR = "#{ROOT_DIR}/lib/resources/urllists"

    # Generic filler urls
    generic_urls = File.readlines("#{URLLISTS_DIR}/generic_urls").sample(self.number_of_generic_urls.to_int)

    # Crime url start
    # cybercrime_urls = File.readlines("#{URLLISTS_DIR}/cybercrime_urls").sample(self.number_of_cybercrime_urls).chomp

    generic_urls.each do |url|
      start_time = DateTime.parse(self.generic_urls_start_time)

      # urls[url] = DateTime.new(
      #     rand(start_time.year..length_time.year + 1),
      #     rand(start_time.month..length_time.month + 1),
      #     rand(start_time.day..length_time.day + 1),
      #     rand(start_time.hour..length_time.hour + 1),
      #     rand(start_time.minute..length_time.minute + 1),
      #     rand(start_time.second..length_time.second + 1)
      # )

      # urls[url] = DateTime.new(
      #     rand(length_time.year - start_time.year),
      #     rand(length_time.month - start_time.month),
      #     rand(length_time.day - start_time.day),
      #     rand(length_time.hour - start_time.hour),
      #     rand(length_time.minute - start_time.minute),
      #     rand(length_time.second - start_time.second)
      # )

      urls[url] = { :url => url ,:title => 'test', :visit_count => '1', :typed_count => '1', :last_visit_time => start_time, :hidden => '0', :favicon_id => '0' }
    end

    puts urls

    self.outputs << urls
  end
end

UrlGenerator.new.run