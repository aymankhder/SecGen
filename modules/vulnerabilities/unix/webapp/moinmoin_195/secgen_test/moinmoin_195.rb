require_relative '../../../../../lib/post_provision_test'

class MoinMoin195Test < PostProvisionTest
  def initialize
    self.module_name = 'moinmoin_195'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    test_service_up
  end
end

MoinMoin195Test.new.run