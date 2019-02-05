require_relative '../../../../../lib/post_provision_test'

class OnlineStoreTest < PostProvisionTest
  def initialize
    self.module_name = 'onlinestore'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
    test_html_returned_content('/index.php', '<title>Welcome to furniture!</title>')
  end
end

OnlineStoreTest.new.run