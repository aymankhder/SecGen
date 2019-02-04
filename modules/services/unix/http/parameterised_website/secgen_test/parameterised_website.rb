require_relative '../../../../../lib/post_provision_test'
require 'json'
require 'net/http'

class ParamWebsiteTest < PostProvisionTest
  def initialize
    self.module_name = 'parameterised_website'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    json_inputs = get_json_inputs
    css_theme = json_inputs['theme'][0]

    if json_inputs['organisation']
      organisation = JSON.parse(json_inputs['organisation'][0])
      employee_1 = organisation['employees'][0]

      test_html_returned_content('/index.html', organisation['business_name'])
      test_html_returned_content('/contact.html', organisation['business_moto'])
      test_html_returned_content('/contact.html', employee_1['name'])
    end

    test_html_returned_content("/css/#{css_theme}", 'Bootswatch v4.0.0')

    test_service_up
  end

end

ParamWebsiteTest.new.run