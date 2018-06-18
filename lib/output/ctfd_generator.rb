# Convert systems objects into a format that can be imported into CTFd
class CTFdGenerator

  POINTS_PER_FLAG = 100
  FREE_POINTS = 200
  
  # How much of the total reward is offset by the cost of all the hints for that flag
  PERCENTAGE_COST_FOR_ALL_HINTS = 0.8 # 80 / number of hints
  PERCENTAGE_COST_FOR_BIG_HINTS = 0.5 # 50% cost for a big hint
  PERCENTAGE_COST_FOR_SOLUTION_HINTS = 0.8 # 80% cost for a solution


  # @param [Object] systems the list of systems
  # @param [Object] scenario the scenario file used to generate
  # @param [Object] time the current time as a string
  def initialize(systems, scenario, time)
    @systems = systems
    @scenario = scenario
    @time = time
  end

  # outputs a hash of filenames with JSON contents
  # @return [Object] hash of files
  def ctfd_files
    
    challenges = []
    hints = []
    keys = []
    
    # TODO REMOVE OFFSET WHEN WORKING?
#     id_offset = rand(1000000000)
    id_offset = 0
    
    challenges << {
              "id"=> 1 + id_offset,
              "name"=>"Free points", 
              "description"=>"Some free points to get you started (and for purchasing hints)!\n Enter flag{FREEPOINTS}",
              "max_attempts"=>0,
              "value"=>FREE_POINTS,
              "category"=>"Freebie",
              "type"=>"standard",
              "hidden"=>0}
    keys << {
              "id"=>1 + id_offset,
              "chal"=>1 + id_offset,
              "type"=>"static",
              "flag"=>"flag{FREEPOINTS}",
              "data"=>nil}

    @systems.each { |system|
      system.module_selections.each { |selected_module|
        # start by finding a flag, and work the way back providing hints
        selected_module.output.each { |output_value|
          if output_value.match(/^flag{.*$/)
            challenge_id = challenges.length + 1 + id_offset
            challenges << {
              "id"=> challenge_id,
              "name"=>"Find the flag", 
              "description"=>"Remember, search for text in the format of flag{SOMETHING}, and submit it for points. If you are stuck a hint may help!",
              "max_attempts"=>0,
              "value"=>POINTS_PER_FLAG,
              "category"=>"#{system.name} VM (#{system.module_selections.first.attributes['platform'].first})",
              "type"=>"standard",
              "hidden"=>0}
            key_id =  keys.length + 1 + id_offset
            keys << {
              "id"=>key_id,
              "chal"=>challenge_id,
              "type"=>"static",
              "flag"=>output_value,
              "data"=>nil}

            collected_hints = []
            system.module_selections.each { |search_module_for_hints|
              if search_module_for_hints.unique_id == selected_module.write_to_module_with_id
                collected_hints = get_module_hints(search_module_for_hints, collected_hints, system.module_selections)
              end
            }
            
            collected_hints.each { |collected_hint|
              hint_id = hints.length + 1 + id_offset
              # weight hints for big_hint
              if collected_hint["hint_type"] == "solution"
                cost=(POINTS_PER_FLAG * PERCENTAGE_COST_FOR_SOLUTION_HINTS).round
              elsif collected_hint["hint_type"] == "big_hint"
                cost=(POINTS_PER_FLAG * PERCENTAGE_COST_FOR_BIG_HINTS).round
              else
                cost=(POINTS_PER_FLAG * PERCENTAGE_COST_FOR_ALL_HINTS / collected_hints.length).round
              end
              hints << {
                "id"=> hint_id,
                "type"=>0,
                "chal"=>challenge_id,
                "hint"=>collected_hint["hint_text"],
                "cost"=>cost
              }
            }
          end
        }
      }
    }
    
    output_hash = {
      "alembic_version.json" => "",
      "awards.json" => "",
      "challenges.json" => challenges_json(challenges),
      "config.json" => config_json(),
      "files.json" => files_json(),
      "hints.json" => hints_json(hints),
      "keys.json" => keys_json(keys),
      "pages.json" => pages_json(),
      "solves.json" => "",
      "tags.json" => "",
      "teams.json" => teams_json(),
      "tracking.json" => "",
      "unlocks.json" => "",
      "wrong_keys.json" => "",
    }
    
    output_hash

  end
  
  def files_json
    return '{"count": 1, "results": [{"id": 1, "chal": null, "location": "fca9b07e1f3699e07870b86061815b1c/logo.svg"}], "meta": {}}'
  end

  def challenges_json(challenges)
    {"count"=>challenges.length,
     "results"=>challenges,
     "meta"=>{}
    }.to_json
  end
  
  def config_json
    config_json_hash = {
      "count" => 31,
      "results" => [
        {
        "id"=>1,
        "key"=>"next_update_check",
        "value"=>"1529096764"
        },
        {
        "id"=>2,
        "key"=>"ctf_version",
        "value"=>"1.2.0"
        },
        {
        "id"=>3,
        "key"=>"ctf_theme",
        "value"=>"core"
        },
        {
        "id"=>4,
        "key"=>"ctf_name",
        "value"=>"SecGenCTF"
        },
        {
        "id"=>5,
        "key"=>"ctf_logo",
        "value"=>"fca9b07e1f3699e07870b86061815b1c/logo.svg"
        },
        {
        "id"=>6,
        "key"=>"workshop_mode",
        "value"=>"0"
        },
        {
        "id"=>7,
        "key"=>"hide_scores",
        "value"=>"0"
        },
        {
        "id"=>8,
        "key"=>"prevent_registration",
        "value"=>"0"
        },
        {
        "id"=>9,
        "key"=>"start",
        "value"=>nil
        },
        {
        "id"=>10,
        "key"=>"max_tries",
        "value"=>"0"
        },
        {
        "id"=>11,
        "key"=>"end",
        "value"=>nil
        },
        {
        "id"=>12,
        "key"=>"freeze",
        "value"=>nil
        },
        {
        "id"=>13,
        "key"=>"view_challenges_unregistered",
        "value"=>"0"
        },
        {
        "id"=>14,
        "key"=>"verify_emails",
        "value"=>"0"
        },
        {
        "id"=>15,
        "key"=>"mail_server",
        "value"=>nil
        },
        {
        "id"=>16,
        "key"=>"mail_port",
        "value"=>nil
        },
        {
        "id"=>17,
        "key"=>"mail_tls",
        "value"=>"0"
        },
        {
        "id"=>18,
        "key"=>"mail_ssl",
        "value"=>"0"
        },
        {
        "id"=>19,
        "key"=>"mail_username",
        "value"=>nil
        },
        {
        "id"=>20,
        "key"=>"mail_password",
        "value"=>nil
        },
        {
        "id"=>21,
        "key"=>"mail_useauth",
        "value"=>"0"
        },
        {
        "id"=>22,
        "key"=>"setup",
        "value"=>"1"
        },
        {
        "id"=>23,
        "key"=>"css",
        "value"=>"img.ctf_logo {\r\n/* from black icon to light grey */\r\nfilter=> invert(0.8) sepia(1) saturate(0) hue-rotate(0deg);\r\n}"
        },
        {
        "id"=>24,
        "key"=>"view_scoreboard_if_authed",
        "value"=>"0"
        },
        {
        "id"=>25,
        "key"=>"prevent_name_change",
        "value"=>"1"
        },
        {
        "id"=>26,
        "key"=>"version_latest",
        "value"=>nil
        },
        {
        "id"=>27,
        "key"=>"mailfrom_addr",
        "value"=>nil
        },
        {
        "id"=>28,
        "key"=>"mg_api_key",
        "value"=>nil
        },
        {
        "id"=>29,
        "key"=>"mg_base_url",
        "value"=>nil
        },
        {
        "id"=>30,
        "key"=>"view_after_ctf",
        "value"=>"1"
        },
        {
        "id"=>31,
        "key"=>"paused",
        "value"=>"0"
        }
      ],
      "meta"=>{}
    }
    
    config_json_hash.to_json
  end

  def hints_json(hints)
    {"count"=>hints.length,
     "results"=>hints,
     "meta"=>{}
    }.to_json
  end

  def keys_json(keys)
    {"count"=>keys.length,
     "results"=>keys,
     "meta"=>{}
    }.to_json
  end

  def pages_json
      return '{
  "count":1,
  "results":[
    {
      "id":1,
      "auth_required":false,
      "title":null,
      "route":"index",
      "html":"<div class=\"row\">\n    <div class=\"col-md-6 offset-md-3\">\n        <h3 class=\"text-center\"></h3>\n        <br>\n        <h4 class=\"text-center\">\n            <a href=\"admin\">Click here</a> to login and setup your CTF\n        </h4>\n    </div>\n</div>",
      "draft":false
    }
  ],
  "meta":{

  }
}'
  end

  def teams_json
    ''
  end
  

  def get_module_hints(search_module_for_hints, collected_hints, all_module_selections)

    if search_module_for_hints.write_to_module_with_id != ""
      # recursion -- show hints for any parent modules
      all_module_selections.each { |search_module_for_hints_recursive|
        if search_module_for_hints_recursive.unique_id == search_module_for_hints.write_to_module_with_id
          get_module_hints(search_module_for_hints_recursive, collected_hints, all_module_selections)
        end
      }
    end

    case search_module_for_hints.module_type
      when "vulnerability"
        case search_module_for_hints.attributes['access'].first
          when "remote"
            collected_hints = collect_hint("A vulnerability that can be accessed/exploited remotely. Perhaps try scanning the system/network?", "#{search_module_for_hints.unique_id}remote", "normal", collected_hints)
          when "local"
            collected_hints = collect_hint("A vulnerability that can only be accessed/exploited with local access. You need to first find a way in...", "#{search_module_for_hints.unique_id}local", "normal", collected_hints)
        end
        type = search_module_for_hints.attributes['type'].first
        unless type == 'system' or type == 'misc' or type == 'ctf' or type == 'local' or type == 'ctf_challenge'
          collected_hints = collect_hint("The system is vulnerable in terms of its #{search_module_for_hints.attributes['type'].first}", "#{search_module_for_hints.unique_id}firsttype", "big_hint", collected_hints)
        end
        collected_hints = collect_hint("The system is vulnerable to #{search_module_for_hints.attributes['name'].first}", "#{search_module_for_hints.unique_id}name", "big_hint", collected_hints)
        if search_module_for_hints.attributes['hint']
          search_module_for_hints.attributes['hint'].each_with_index { |hint, i|
            collected_hints = collect_hint(clean_hint(hint), "#{search_module_for_hints.unique_id}hint#{i}", "big_hint", collected_hints)  # .gsub(/\s+/, ' ')
          }
        end
        if search_module_for_hints.attributes['solution']
          solution = search_module_for_hints.attributes['solution'].first
          collected_hints = collect_hint(clean_hint(solution), "#{search_module_for_hints.unique_id}solution", "solution", collected_hints)
        end
        if search_module_for_hints.attributes['msf_module']
          collected_hints = collect_hint("Can be exploited using the Metasploit module: #{search_module_for_hints.attributes['msf_module'].first}", "#{search_module_for_hints.unique_id}msf_module", "big_hint", collected_hints)
        end

      when "service"
        collected_hints = collect_hint("The flag is hosted using #{search_module_for_hints.attributes['type'].first}", "#{search_module_for_hints.unique_id}type", "normal", collected_hints)
      when "encoder"
        collected_hints = collect_hint("The flag is encoded/hidden somewhere", "#{search_module_for_hints.unique_id}itsanencoder", "normal", collected_hints)
        if search_module_for_hints.attributes['type'].include? 'string_encoder'
          collected_hints = collect_hint("There is a layer of encoding using a standard encoding method, look for an unusual string of text and try to figure out how it was encoded, and decode it", "#{search_module_for_hints.unique_id}stringencoder", "normal", collected_hints)
        end
        if search_module_for_hints.attributes['solution'] == nil
          collected_hints = collect_hint("The flag is encoded using a #{search_module_for_hints.attributes['name'].first}", "#{search_module_for_hints.unique_id}name", "big_hint", collected_hints)
        end
        if search_module_for_hints.attributes['hint']
          search_module_for_hints.attributes['hint'].each_with_index { |hint, i|
            collected_hints = collect_hint(clean_hint(hint), "#{search_module_for_hints.unique_id}hint#{i}", "big_hint", collected_hints)
          }
        end
        if search_module_for_hints.attributes['solution']
          solution = search_module_for_hints.attributes['solution'].first
          collected_hints = collect_hint(clean_hint(solution), "#{search_module_for_hints.unique_id}solution", "solution", collected_hints)
        end
      when "generator"
        if search_module_for_hints.attributes['hint']
          search_module_for_hints.attributes['hint'].each_with_index { |hint, i|
            collected_hints = collect_hint(clean_hint(hint), "#{search_module_for_hints.unique_id}hint#{i}", "big_hint", collected_hints)
          }
        end
        if search_module_for_hints.attributes['solution']
          solution = search_module_for_hints.attributes['solution'].first
          collected_hints = collect_hint(clean_hint(solution), "#{search_module_for_hints.unique_id}solution", "solution", collected_hints)
        end
    end

    collected_hints
  end
end

def collect_hint(hint_text, hint_id, hint_type, collected_hints)
  collected_hints << {
    "hint_text"=>hint_text,
    "hint_type"=>hint_type,
    "hint_id"=>hint_id
  }
end

def clean_hint str
  str.tr("\n",'').gsub(/\s+/, ' ')
end
