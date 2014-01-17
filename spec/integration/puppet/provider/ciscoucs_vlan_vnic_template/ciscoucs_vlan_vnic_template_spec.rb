#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_vlan_vnic_template).provider(:default) do

	ciscoucs_vlan_vnic_template_yml =  YAML.load_file(my_fixture('ciscoucs_vlan_vnic_template.yml'))
	update_vlan1 = ciscoucs_vlan_vnic_template_yml['UpdateVlanVnicTemplate1']  

	transport_yml =  YAML.load_file('transport.yml')
	transport_node = transport_yml['transport']
  
	let(:ciscoucs_vlan_vnic_template1) do
		@catalog = Puppet::Resource::Catalog.new
		transport = Puppet::Type.type(:transport).new({
			:name 		=> transport_node['name'],
			:username 	=> transport_node['username'],
			:password 	=> transport_node['password'],
			:server   	=> transport_node['server'],
		})
		@catalog.add_resource(transport)

		Puppet::Type.type(:ciscoucs_vlan_vnic_template).new(
			:name               	=> update_vlan1['name'],
			:vnictemplateorg   		=> update_vlan1['vnictemplateorg'],
			:transport          	=> transport, 
			:catalog            	=> @catalog,
			:vlanname       		=> update_vlan1['vlanname'],
			:defaultnet         	=> update_vlan1['defaultnet'],
			:ensure         		=> update_vlan1['ensure'],
		)
	end  
   
	update_vlan2 = ciscoucs_vlan_vnic_template_yml['UpdateVlanVnicTemplate2']  
   
	let :ciscoucs_vlan_vnic_template2 do
		@catalog = Puppet::Resource::Catalog.new
		transport = Puppet::Type.type(:transport).new({
			:name 		=> transport_node['name'],
			:username 	=> transport_node['username'],
			:password 	=> transport_node['password'],
			:server   	=> transport_node['server'],

		})
		@catalog.add_resource(transport)

		Puppet::Type.type(:ciscoucs_vlan_vnic_template).new(
			:name               	=> update_vlan2['name'],
			:vnictemplateorg   		=> update_vlan2['vnictemplateorg'],
			:transport          	=> transport, 
			:catalog            	=> @catalog,
			:vlanname       		=> update_vlan2['vlanname'],
			:defaultnet         	=> update_vlan2['defaultnet'],
			:ensure         		=> update_vlan2['ensure'],
		)
	end  
 
	describe "when updating vlan in vnic template - scenario1" do     
		it "should be able to update the vlan in vnin template" do
			ciscoucs_vlan_vnic_template1.provider.create
		end
	end
 
	describe "when updating vlan in vnic template - scenario2" do
		it "should be able to update the vlan in vnin template" do
			ciscoucs_vlan_vnic_template2.provider.create
		end
	end
	
 end