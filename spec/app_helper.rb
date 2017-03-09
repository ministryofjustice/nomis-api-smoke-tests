require_relative 'spec_helper'
require 'byebug'

$: << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib/'))

require 'nomis/api/request'
require 'nomis/api/parsed_response'
