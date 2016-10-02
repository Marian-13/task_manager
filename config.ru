# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'faye'

use Faye::RackAdapter, mount: '/faye', timeout: 25

run Rails.application
