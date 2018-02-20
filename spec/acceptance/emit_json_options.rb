require 'spec_helper_acceptance'
require 'util'
require 'json'

include PuppetStrings::Acceptance::Util

describe 'Emitting JSON' do
  expected = {
    "puppet_classes" => [],
    "defined_types" => [],
    "resource_types" => [],
    "providers" => [],
    "puppet_functions" => [
      "name" => "function3x",
      "file" => "/etc/puppet/modules/test/lib/puppet/parser/functions/function3x.rb",
      "line" => 1,
      "type" => "ruby3x",
      "signatures" => [
        {
          "signature" =>"function3x()",
          "docstring" => {
            "text" => "This is the function documentation for `function3x`",
            "tags" => [
              {
                "tag_name"=>"return",
                "text"=>"",
                "types"=>["Any"]
              }
            ]
          }
        },
      ],
      "docstring" => {
        "text" => "This is the function documentation for `function3x`",
        "tags" => ["tag_name" => "return", "text" => "", "types" => ["Any"]]},
        "source" => "Puppet::Parser::Functions.newfunction(:function3x, :doc => \"This is the function documentation for `function3x`\") do |args|\nend"
    ]
  }

  it 'should emit JSON to stdout when using --format json and --stdout' do
    test_module_path = get_test_module_path(master, /Module test/)
    on master, puppet('strings', 'generate', '--format json', "#{test_module_path}/lib/puppet/parser/functions/function3x.rb") do
      output = stdout.chomp
      expect(JSON.parse(output)).to eq(expected)
    end
  end

  it 'should write JSON to a file when using --format json and --out' do
    test_module_path = get_test_module_path(master, /Module test/)
    tmpfile = master.tmpfile('json_output.json')
    on master, puppet('strings', 'generate', '--format json', "--out #{tmpfile}", "#{test_module_path}/lib/puppet/parser/functions/function3x.rb")
    output = read_file_on(master, tmpfile)
    expect(JSON.parse(output)).to eq(expected)
  end
end
