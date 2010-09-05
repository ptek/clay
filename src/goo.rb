#!/usr/bin/env ruby

require 'rubygems'
#require 'bundler/setup'
require 'mustache'
require 'rdiscount'
require 'ftools'

module Goo
  VERSION = "0.1"
  
  def self.init project_name
    print "creating the structure ..."
    File.makedirs "#{project_name}/pages", "#{project_name}/layout", "#{project_name}/posts"
    puts " complete"
  end
  
  def self.build
    print "building ..."
    puts " complete"
  end
  
  def self.serve
    puts "starting server"
    while true do
      
    end
  end
end
