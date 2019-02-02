# Post Provision Testing
#
# This file will be copied into each project folder at creation time.
# It will be required from each of the modules/secgen_tests/module_name.rb test scripts
#
# Test classes must: require_relative '../../../../../lib/post_provision_test'

require_relative '../../../lib/helpers/print.rb'
require 'json'
require 'base64'

require 'socket'
require 'timeout'

class PostProvisionTest
  attr_accessor :project_path
  attr_accessor :system_ip
  attr_accessor :module_name
  attr_accessor :module_path
  attr_accessor :json_inputs

  def run
    Print.info "Running tests for #{self.module_name}"
    test_module
  end

  def test_module
    # Override me with testing details
  end

  def get_system_ip
    vagrant_file_path = "#{get_project_path}/Vagrantfile"
    vagrantfile = File.read(vagrant_file_path)
    ip_line = vagrantfile.split("\n").delete_if { |line| !line.include? "# ip_address_for_#{get_system_name}"}[0]
    ip_address = ip_line.split('=')[-1]
    if ip_address == "DHCP"
      "FAILED: Cannot test against dynamic IPs" # TODO: fix this so that we grab dynamic IP address (maybe from vagrant?)
    else
      ip_address
    end
  end

  def get_json_inputs
    json_inputs_path = "#{File.expand_path('../', self.module_path)}/secgen_functions/files/json_inputs/*"
    json_inputs_files = Dir.glob(json_inputs_path)
    json_inputs_files.delete_if { |path| !path.include?(self.module_name) }
    JSON.parse(Base64.strict_decode64(File.read(json_inputs_files.first)))
  end

  # Pass __FILE__ in from subclasses
  def get_module_path(file_path)
    "#{File.expand_path('..', File.dirname(file_path))}"
  end

  # Note: returns proftpd_testing
  def get_system_name
    get_system_path.match(/.*?([^\/]*)$/i).captures[0]
  end

  # Note: returns /home/thomashaw/git/SecGen/projects/SecGen20190202_010552/puppet/proftpd_testing
  def get_system_path
    "#{File.expand_path('../../', self.module_path)}"
  end

  # Note: returns /home/thomashaw/git/SecGen/projects/SecGen20190202_010552/
  def get_project_path
    "#{File.expand_path('../../../../', self.module_path)}"
  end

  ##############################
  ## Useful testing functions ##
  ##############################

  def is_port_open?(ip, port)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
      # ignored
    end
    false
  end

end