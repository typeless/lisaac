# encoding: utf-8

Given /^lisaac\/(.*) is in the PATH$/ do |dir|
  new_path = $lisaac_path + "/" + dir;
  ENV['PATH'] = new_path + ":" + ENV['PATH'];
end

Given /^make.lip is installed$/ do
  if not File.exists?("#{$lisaac_path}/make.lip") then
    FileUtils.ln_s("make.lip.sample", "#{$lisaac_path}/make.lip")
  end
end

Given /^I am in an empty directory$/ do
  @oldcwd = FileUtils.pwd();
  dir = "#{$lisaac_path}/tmp";
  FileUtils.cd($lisaac_path);
  FileUtils.remove_dir(dir) rescue nil;
  FileUtils.mkdir_p(dir);
  FileUtils.cd(dir);
end

Given /^I am in the lisaac directory$/ do |dir|
  @oldcwd = FileUtils.pwd();
  FileUtils.cd($lisaac_path);
end

Given /^I am in "(.*)"$/ do |dir|
  @oldcwd = FileUtils.pwd();
  FileUtils::mkdir_p(dir);
  FileUtils.cd(dir);
end

Given /^a file "(.*)":?$/ do |filename, filecontent|
  FileUtils::mkdir_p(File.dirname(filename));
  f = File.new(filename, "w");
  f.write(filecontent);
  f.close();
end

Given /^a file "(.*)" constructed with:?$/ do |filename, script|
  FileUtils::mkdir_p(File.dirname(filename));
  f = File.new(filename, "w");
  f.write(`#{script}`);
  f.close();
end

Given /^a file "(.*)" constructed with (.*)$/ do |filename, script|
  FileUtils::mkdir_p(File.dirname(filename));
  f = File.new(filename, "w");
  f.write(`#{script}`);
  f.close();
end

When /^I run "([^"]*)"(?: in "([^"]*)")?$/ do |commandline, dir|
  if dir then
    olddir = FileUtils.pwd();
    FileUtils.cd(dir);
  end
  @last_command_output = `#{commandline} 2>&1`;
  @last_exit_code = $?.to_i;
  if dir then
    FileUtils.cd(olddir);
  end
end

When /^I run ([^"].*)$/ do |commandline|
  When("I run \"#{commandline}\"")
end

When /^I print the last command output$/ do
  puts @last_command_output;
end

When /^I print the last exit code$/ do
  puts @last_exit_code;
end

Then /^it should (fail|pass)$/ do |success|
  if success == 'fail'
    @last_exit_code.should_not == 0
  else
    if @last_exit_code != 0
      raise "Failed with exit status #{@last_exit_code}\nOutput:\n#{@last_command_output}\n"
    end
  end
end

Then /^it should (fail|pass) with:?$/ do |success, output|
  @last_command_output.should == output
  Then("it should #{success}")
end

Then /^the output should contains?:?$/ do |text|
  @last_command_output.should include(text)
end

Then /^the output should not contains?:?$/ do |text|
  @last_command_output.should_not include(text)
end

Then /^the output should be:?$/ do |text|
  @last_command_output.should == text
end

Then /^"([^\"]*)" should match "([^\"]*)"$/ do |file, text|
  File.open(file, Cucumber.file_mode('r')).read.should =~ Regexp.new(text)
end

Then /^print output$/ do
  puts @last_command_output
end

Then /^"([^\"]*)" should exist$/ do |file|
  File.exists?(file).should be_true
end

Then /^"([^\"]*)" (?:should not|shouldn't) exist$/ do |file|
  File.exists?(file).should be_false
end
