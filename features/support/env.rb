# encoding: utf-8
require 'spec/expectations'
require 'cucumber/formatter/unicode'
require 'tempfile'

$lisaac_path = File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))))

Before do
  $current_dir = FileUtils::pwd();
  File.dirname(__FILE__)
end

After do |scenario|
  FileUtils::cd($current_dir);
end
