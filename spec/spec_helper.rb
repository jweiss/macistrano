require 'rubygems'
gem 'rspec'

$:.unshift File.join(File.dirname(__FILE__), '../model')
$:.unshift File.join(File.dirname(__FILE__), '../controller')
require File.join(File.dirname(__FILE__), '../rb_main')
