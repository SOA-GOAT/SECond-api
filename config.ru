# frozen_string_literal: true

require 'faye'
require_relative './init'

use Faye::RackAdapter, mount: '/faye', timeout: 25
run SECond::App.freeze.app
