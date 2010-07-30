# encoding: utf-8
require 'spec/expectations'
require 'cucumber/formatter/unicode'
require 'tempfile'

$lisaac_path = File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))))
$global_lisaac_options = ""
$lisaac_name="lisaac"

ENV['PATH'] = "#{$lisaac_path}/bin:#{$lisaac_path}:#{ENV['PATH']}";
if ENV['CUKE_LISAAC_PATH'] then
  ENV['PATH'] = "#{ENV['CUKE_LISAAC_PATH']}:#{ENV['PATH']}";
end
if ENV['CUKE_LISAAC_NAME'] then
  $lisaac_name = ENV['CUKE_LISAAC_NAME'];
end

FileUtils.mkdir_p("#{$lisaac_path}/lib/extra")
FileUtils.mkdir_p("#{$lisaac_path}/lib/unstable")

Before do
  $current_dir = FileUtils::pwd();
  File.dirname(__FILE__)
  if not File.exists?("#{$lisaac_path}/make.lip") then
    FileUtils.ln_s("make.lip.sample", "#{$lisaac_path}/make.lip")
  end
end

After do |scenario|
  FileUtils::cd($current_dir);
end

def lisaac_compile(li="", lip="", options="")
  commandline = "#{$lisaac_name} #{lip} #{li} #{$global_lisaac_options} #{options}"
  # puts "#{commandline}\n"
  @last_command_output = `#{commandline} 2>&1`;
  @last_exit_code = $?.to_i;
end

