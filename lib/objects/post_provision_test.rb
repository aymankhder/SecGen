# Post Provision Testing
#
# This file will be copied into each project folder at creation time.
# It will be required from each of the modules/secgen_tests/module_name.rb test scripts
#
# Test classes must: require_relative '../../../../../lib/post_provision_test'

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
  attr_accessor :port
  attr_accessor :outputs

  def initialize
    self.system_ip = get_system_ip
    self.json_inputs = get_json_inputs
    self.port = get_port
    self.outputs = []
  end

  def run
    test_module
    puts self.outputs
  end

  def test_module
    # Call super first in overriden methods
    self.outputs << "Running tests for #{self.module_name}"
  end

  #####################
  # Testing Functions #
  #####################

  def test_service_up
    if is_port_open? system_ip, self.port
      self.outputs << "PASSED: Port #{self.port} is open at #{get_system_ip} (#{get_system_name})!"
    else
      self.outputs << "FAILED: Port #{self.port} is closed at #{get_system_ip} (#{get_system_name})!"
    end
  end

  ##################
  # Misc Functions #
  ##################

  def get_system_ip
    vagrant_file_path = "#{get_project_path}/Vagrantfile"
    vagrantfile = File.read(vagrant_file_path)
    ip_line = vagrantfile.split("\n").delete_if { |line| !line.include? "# ip_address_for_#{get_system_name}"}[0]
    ip_address = ip_line.split('=')[-1]
    if ip_address == "DHCP"
      self.outputs << "FAILED: Cannot test against dynamic IPs" # TODO: fix this so that we grab dynamic IP address (maybe from vagrant?)
      exit(1)
    else
      ip_address
    end
  end

  def get_json_inputs
    json_inputs_path = "#{File.expand_path('../', self.module_path)}/secgen_functions/files/json_inputs/*"
    json_inputs_files = Dir.glob(json_inputs_path)
    json_inputs_files.delete_if { |path| !path.include?(self.module_name) }
    if json_inputs_files.size > 0
      return JSON.parse(Base64.strict_decode64(File.read(json_inputs_files.first)))
    end
    {}
  end

  def get_port
    if get_json_inputs != {} and get_json_inputs['port'] != nil
      get_json_inputs['port'][0].to_i
    else
      -1
    end
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