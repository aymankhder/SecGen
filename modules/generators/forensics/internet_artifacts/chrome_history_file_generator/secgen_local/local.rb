#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_generator.rb'
require 'date'
require 'sqlite3'
require 'fileutils'

# class ChromeHistoryFileGenerator < StringGenerator
#   attr_accessor :history_urls
#
#   def initialize
#     super
#     self.module_name = 'Chrome history file generator'
#     self.history_urls = ''
#   end
#
#   def generate
    local_user = 'vagrant'
    chrome_user = 'Default'

    history_urls = {
        'url_test_1' => {:url => 'test1', :title => 'test1', :visit_count => '1', :typed_count => '1', :last_visit_time => 10, :hidden => '0', :favicon_id => '0'},
        'url_test_2' => {:url => 'test2', :title => 'test2', :visit_count => '2', :typed_count => '2', :last_visit_time => 10, :hidden => '0', :favicon_id => '0'},
        'url_test_3' => {:url => 'test3', :title => 'test3', :visit_count => '3', :typed_count => '3', :last_visit_time => 10, :hidden => '0', :favicon_id => '0'}
    }

    FileUtils.cp('../templates/History.source', '../templates/History')

    database = SQLite3::Database.new( "../templates/History" ) do |db|
      history_urls.each_value do |details|
      db.execute(
            "INSERT INTO urls(url, title, visit_count, typed_count, last_visit_time, hidden, favicon_id)
VALUES ('#{details[:url]}', '#{details[:title]}', '#{details[:visit_count]}', '#{details[:typed_count]}', '#{details[:last_visit_time]}', '#{details[:hidden]}', '#{details[:favicon_id]}');"
      )
      end

      # db.execute( "select * from urls" ) do |row|
      #   puts row
      #   # p row
      # end

#           "INSERT INTO urls(url, title, visit_count, typed_count, last_visit_time, hidden, favicon_id)
# VALUES ('test_url', 'test_title', '1', '1', '1', '0', '0');"

    end

    # puts self.history_urls
    #
    # self.outputs << database
  # end
# end
#
# ChromeHistoryFileGenerator.new.run