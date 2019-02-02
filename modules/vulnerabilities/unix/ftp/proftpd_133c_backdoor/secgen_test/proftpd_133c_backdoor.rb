require_relative '../../../../../lib/post_provision_test'

class Proftpd133cBackdoorTest < PostProvisionTest

  attr_accessor :ftp_port
  def initialize
    super
    self.module_name = 'proftpd_133c_backdoor'
    self.module_path = get_module_path(__FILE__)
    self.json_inputs = get_json_inputs
    self.ftp_port = get_json_inputs['port'].to_i
    # Print.info self.json_inputs
    # Print.info "get_system_name: #{get_system_name}"
    # Print.info "get_system_path: #{get_system_path}"
    # Print.info "get_project_path: #{get_project_path}"
  end

  def test_module
    # TODO: Need to determine how to handle the output... see other Open3.capture3 module and stdout print pass/fail perhaps?
    # TODO: Raise an exception? Return false? Print the PASSED / FAILED only?

    if is_port_open? "172.16.0.5", "21"
      Print.info "PASSED: Port #{ftp_port} is open on #{get_system_name}!"
    else
      Print.err "FAILED: Port #{ftp_port} is closed on #{get_system_name}!"
    end
  end
end

Proftpd133cBackdoorTest.new.run