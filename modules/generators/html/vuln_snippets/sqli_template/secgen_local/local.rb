#!/usr/bin/ruby
require_relative '../../../../../../lib/objects/local_string_encoder.rb'

class SQLiTemplateGenerator < StringEncoder
  attr_accessor :table_headings
  attr_accessor :difficulty

  def initialize
    super
    self.module_name = 'SQLi Snippet Generator'
    self.table_headings = ''
    self.difficulty = ''
  end

  def encode_all
    #inputs: difficulty and database table headings
    headings = "#{self.table_headings}"

    #Formatting: table headings for database
    headings_array = headings.split(',')
    heading_name = "Review"

    #Query: input of table headings to differentiate queries, these are queries from lauras code but used as a template here
    query_1 = "$statement = \"INSERT INTO " + headings_array[0] + " (" + headings + ") VALUES" + "('$question','$name', '$mobile', '$email')\";"
    query_2 = "$statement = \"INSERT INTO " + headings_array[0] + " (" + headings_array[0] + "," + headings_array[1] + ") " + "VALUES ('$question', '$name')\";"

    #input: Attack vector definition
    vector_1 = "#{WS_ATTACK_DIR}/sqli/vectors/vector_1"
    vector_2 = "#{WS_ATTACK_DIR}/sqli/vectors/vector_2"

    #Make sure there are no unexpected values
    difficulties = ['easy', 'medium', 'hard', 'impossible']
    unless difficulties.include? self.difficulty
      self.difficulty = difficulties.sample
    end

    #Vulnerabilities
    vuln_root_directory = "#{WS_ATTACK_DIR}/sqli/vulnerabilities/#{difficulty}/"
    vuln_1 = vuln_root_directory + "vuln_1"
    vuln_2 = vuln_root_directory + "vuln_2"
    vuln_3 = vuln_root_directory + "vuln_3"
    vuln_4 = vuln_root_directory + "vuln_4"
    vuln_5 = vuln_root_directory + "vuln_5"

    vuln_option_1 = difficulty == 'impossible' ? vuln_1 : [vuln_1, vuln_2, vuln_3].sample
    vuln_option_2 = difficulty == 'impossible' ? vuln_2 : [vuln_4, vuln_5].sample

    case [0, 1].sample
    when 0
      vector_template = File.read(vector_1, chomp: true)
      vuln_template = File.read(vuln_option_1, chomp: true)
      query = query_1
      method = "POST"
    else
      vector_template = File.read(vector_2, chomp: true)
      vuln_template = File.read(vuln_option_2, chomp: true)
      query = query_2
      method = "GET"
    end

    submit = "
        if (mysqli_query($conn2, $statement)){
        ?><div class=\"col-12\"id=\"success\">Thank you <?php echo $name;?> for your #{heading_name}!</div>
        <?php
         }
     }
     ?>"

    heading = "<div class=\"row\"><h3>Please leave us a #{heading_name}!</h3></div>\n"

    query_concat = "<?php\nif(isset($_#{method}['go'])){ \n" + vuln_template + query + "\n" + submit

    submit_output = "
    <div class=\"row\">
        <h3>Other reviews</h3><br />
          <?php
          	$statement2 = \"SELECT * FROM #{headings_array[0]}\";
          	$result = mysqli_query($conn2, $statement2);
          	while ($row = mysqli_fetch_assoc($result)){
              ?>
              <div class=\"other-review\">
                <div><?php echo $row['#{headings_array[0]}']; ?></div>
                <div id=\"left-by\"><?php echo $row['#{headings_array[1]}']; ?></div>
              </p>
            </div>
              <?php
          	}
          ?>
    </div>"

    #concatenation of all selected sections of file read for output
    snippet = heading + vector_template + "\n" + query_concat + "\n" + submit_output

    #output of the generator
    self.outputs << snippet
  end

  def get_options_array
    super + [['--table_headings', GetoptLong::REQUIRED_ARGUMENT],
             ['--difficulty', GetoptLong::REQUIRED_ARGUMENT]]
  end

  def process_options(opt, arg)
    super
    case opt
    when '--difficulty'
      self.difficulty << arg;
    when '--table_headings'
      self.table_headings << arg;
    end
  end

  def encoding_print_string
    'difficulty: ' + self.difficulty.to_s + print_string_padding +
      'table_headings: ' + self.table_headings.to_s
  end
end

SQLiTemplateGenerator.new.run
