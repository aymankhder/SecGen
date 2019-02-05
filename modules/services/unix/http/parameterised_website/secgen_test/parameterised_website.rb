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
    test_service_up
    test_organisation_functionality(json_inputs)
    test_additional_page(json_inputs)
    test_html_returned_content("/css/#{json_inputs['theme'][0]}", 'Bootswatch v4.0.0')
  end

  def test_organisation_functionality(json_inputs)
    if json_inputs['organisation'] and
       json_inputs['organisation'][0] and
       json_inputs['organisation'][0] != ''

      organisation = JSON.parse(json_inputs['organisation'][0])
      employee_1 = organisation['employees'][0]

      test_html_returned_content('/index.html', organisation['business_name'])
      test_html_returned_content('/contact.html', organisation['business_moto'])
      test_html_returned_content('/contact.html', employee_1['name'])
    end
  end


  def test_additional_page(json_inputs)
    if json_inputs['additional_page_filenames'] and
       json_inputs['additional_page_filenames'][0] and
       json_inputs['additional_page_filenames'][0].include? 'html' and
       json_inputs['additional_pages'] and
       json_inputs['additional_pages'][0]

      page_name = json_inputs['additional_page_filenames'][0]
      page_name = "/#{page_name}" if page_name.split[0] != '/'

      test_html_returned_content(page_name, json_inputs['additional_pages'][0], true)
    end
  end

end

ParamWebsiteTest.new.run