#
# NXAPI implementation of AaaAuthenticationLogin class
#
# April 2015, Alex Hunsberger
#
# Copyright (c) 2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'node_util'

module Cisco
  # NXAPI implementation of AAA Authentication Login class
  class AaaAuthenticationLogin < NodeUtil
    # There is no "feature aaa" or "aaa new-model" on nxos, and only one
    # instance which is always available

    # TODO: Missing properties: mschap, mschapv2, chap, default fallback,
    # console fallback.

    def self.ascii_authentication
      !node.config_get('aaa_authentication_login',
                       'ascii_authentication').nil?
    end

    def self.ascii_authentication=(val)
      no_cmd = val ? '' : 'no'
      node.config_set('aaa_authentication_login',
                      'ascii_authentication', no_cmd)
    end

    def self.default_ascii_authentication
      node.config_get_default('aaa_authentication_login',
                              'ascii_authentication')
    end

    def self.chap
      !node.config_get('aaa_authentication_login', 'chap').nil?
    end

    def self.chap=(val)
      no_cmd = val ? '' : 'no'
      node.config_set('aaa_authentication_login', 'chap', no_cmd)
    end

    def self.default_chap
      node.config_get_default('aaa_authentication_login', 'chap')
    end

    def self.error_display
      !node.config_get('aaa_authentication_login', 'error_display').nil?
    end

    def self.error_display=(val)
      no_cmd = val ? '' : 'no'
      node.config_set('aaa_authentication_login', 'error_display', no_cmd)
    end

    def self.default_error_display
      node.config_get_default('aaa_authentication_login', 'error_display')
    end

    def self.mschap
      !node.config_get('aaa_authentication_login', 'mschap').nil?
    end

    def self.mschap=(val)
      no_cmd = val ? '' : 'no'
      node.config_set('aaa_authentication_login', 'mschap', no_cmd)
    end

    def self.default_mschap
      node.config_get_default('aaa_authentication_login', 'mschap')
    end

    def self.mschapv2
      !node.config_get('aaa_authentication_login', 'mschapv2').nil?
    end

    def self.mschapv2=(val)
      no_cmd = val ? '' : 'no'
      node.config_set('aaa_authentication_login', 'mschapv2', no_cmd)
    end

    def self.default_mschapv2
      node.config_get_default('aaa_authentication_login', 'mschapv2')
    end
  end
end
