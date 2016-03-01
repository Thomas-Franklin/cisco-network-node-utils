# Copyright (c) 2013-2016 Cisco and/or its affiliates.
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

require_relative 'ciscotest'
require_relative '../lib/cisco_node_utils/bridge_domain'
require_relative '../lib/cisco_node_utils/vlan'

include Cisco

# TestBridgeDomain - Minitest for bridge domain class.
class TestBridgeDomain < CiscoTestCase
  @@cleaned = false # rubocop:disable Style/ClassVars

  def cleanup
    BridgeDomain.allbds.each do |_bd, obj|
      obj.destroy
    end
  end

  def setup
    super
    cleanup unless @@cleaned
    @@cleaned = true # rubocop:disable Style/ClassVars
  end

  def teardown
    cleanup
  end

  def test_single_bd_create_destroy
    bd = BridgeDomain.new('100', true)
    bds = BridgeDomain.allbds
    assert(bds.key?('100'), 'Error: failed to create bridge-domain 100')

    bd.destroy
    bds = BridgeDomain.allbds
    refute(bds.key?('100'), 'Error: failed to destroy bridge-domain 100')
  end

  def test_bd_create_if_vlan_exists
    vlan = Vlan.new(100)
    assert_raises(RuntimeError,
                  'Vlan already exist did not raise RuntimeError') do
      BridgeDomain.new(100)
    end
    vlan.destroy
  end

  def test_multiple_bd_create_destroy
    create = '101-102,120'
    bdlist = BridgeDomain.bd_ids_to_array(create)

    bd = BridgeDomain.new(create, true)
    bds = BridgeDomain.allbds
    bdlist.each do |id|
      assert(bds.key?(id.to_s), 'Error: failed to create bridge-domain ' << id)
    end

    bd.destroy
    bds = BridgeDomain.allbds
    bdlist.each do |id|
      refute(bds.key?(id.to_s), 'Error: failed to destroy bridge-domain ' << id)
    end
  end

  def test_bd_shutdown
    bd = BridgeDomain.new(101)
    refute(bd.shutdown)
    bd.shutdown = true
    assert(bd.shutdown)
    bd.destroy
  end

  def test_bd_name
    bd = BridgeDomain.new(101)
    assert_equal(bd.default_name, bd.name,
                 'Error: Bridge-Domain name not initialized to default')

    name = 'Pepsi'
    bd.name = name
    assert_equal(name, bd.name,
                 'Error: Bridge-Domain name not updated to #{name}')

    bd.name = bd.default_name
    assert_equal(bd.default_name, bd.name,
                 'Error: Bridge-Domain name not restored to default')
    bd.destroy
  end

  def test_bd_fabric_control
    bd = BridgeDomain.new('100')
    assert_equal(bd.default_fabric_control, bd.fabric_control,
                 'Error: Bridge-Domain fabric-control is not matching')
    bd.fabric_control = true
    assert(bd.fabric_control)
    bd.destroy
  end

  def test_bd_member_vni
    bd = BridgeDomain.new(100)
    assert_equal(bd.default_member_vni, bd.member_vni,
                 'Error: Bridge-Domain is mapped to different vnis')

    vni = '5000'
    bd.send(:set_member_vni=, true, vni)
    assert_equal(vni, bd.member_vni,
                 'Error: Bridge-Domain is mapped to different vnis')

    bd.send(:set_member_vni=, false, vni)
    assert_equal(bd.default_member_vni, bd.member_vni,
                 'Error: Bridge-Domain is mapped to different vnis')

    bd.destroy
  end

  def test_mapped_bd_member_vni
    bd = BridgeDomain.new(100)
    assert_equal(bd.default_member_vni, bd.member_vni,
                 'Error: Bridge-Domain is mapped to different vnis')

    vni = '5000'
    bd.send(:set_member_vni=, true, vni)
    assert_equal(vni, bd.member_vni,
                 'Error: Bridge-Domain is mapped to different vnis')
    vni = '6000'
    assert_raises(RuntimeError,
                  'Should raise RuntimeError as BD already mapped to vni ') do
      bd.send(:set_member_vni=, true, vni)
    end
    bd.destroy
  end

  def test_another_bd_as_fabric_control
    bd = BridgeDomain.new(100)
    assert_equal(bd.default_fabric_control, bd.fabric_control,
                 'Error: Bridge-Domain fabric-control is not matching')
    bd.fabric_control = true
    assert(bd.fabric_control)
    another_bd = BridgeDomain.new(101)

    assert_raises(RuntimeError,
                  'BD misconfig did not raise RuntimeError') do
      another_bd.fabric_control = true
    end
    bd.destroy
    another_bd.destroy
  end
end
