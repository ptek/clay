#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'mustache'
require 'rdiscount'

module Goo
  VERSION = "0.1"
  
  def self.init
    print "creating the structure ..."
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
