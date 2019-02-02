require_relative '../../../../../lib/post_provision_test'

class MySQLStretchTest < PostProvisionTest
  def initialize
    self.module_name = 'mysql_stretch_compatible'
    self.module_path = get_module_path(__FILE__)
    super
    self.port = 3306
  end

  def test_module
    super
    test_service_up
  end
end

MySQLStretchTest.new.run