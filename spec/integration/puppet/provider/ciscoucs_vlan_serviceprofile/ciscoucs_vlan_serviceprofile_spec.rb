#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_vlan_serviceprofile).provider(:default) do

	ciscoucs_vlan_serviceprofile_yml =  YAML.load_file(my_fixture('ciscoucs_vlan_serviceprofile.yml'))
	update_vlan1 = ciscoucs_vlan_serviceprofile_yml['UpdateVlanServiceProfile1']  

	transport_yml =  YAML.load_file(my_fixture('transport.yml'))
	transport_node = transport_yml['transport']
  
	let(:update_vlan_service_profile1) do
		@catalog = Puppet::Resource::Catalog.new
		transport = Puppet::Type.type(:transport).new({
			:name 		=> transport_node['name'],
			:username 	=> transport_node['username'],
			:password 	=> transport_node['password'],
			:server   	=> transport_node['server'],
		})
		@catalog.add_resource(transport)

		Puppet::Type.type(:ciscoucs_serviceprofile).new(
			:name               => update_vlan1['name'],
			:serviceprofileorg  => update_vlan1['serviceprofileorg'],
			:transport          => transport, 
			:catalog            => @catalog,
			:vlan_name       	=> update_vlan1['vlan_name'],
			:defaultnet         => update_vlan1['defaultnet'],
			:vnic       		=> update_vlan1['vnic'],
			:ensure         	=> update_vlan1['ensure']
		)
	end  
   
	update_vlan2 = ciscoucs_vlan_serviceprofile_yml['UpdateVlanServiceProfile2'] 
   
	let(:update_vlan_service_profile2) do
		@catalog = Puppet::Resource::Catalog.new
		transport = Puppet::Type.type(:transport).new({
			:name 		=> transport_node['name'],
			:username 	=> transport_node['username'],
			:password 	=> transport_node['password'],
			:server   	=> transport_node['server'],
		})
		@catalog.add_resource(transport)

		Puppet::Type.type(:ciscoucs_serviceprofile).new(
			:name               => update_vlan2['name'],
			:serviceprofileorg  => update_vlan2['serviceprofileorg'],
			:transport          => transport, 
			:catalog            => @catalog,
			:vlan_name       	=> update_vlan2['vlan_name'],
			:defaultnet         => update_vlan2['defaultnet'],
			:vnic       		=> update_vlan2['vnic'],
			:ensure         	=> update_vlan2['ensure']
		)
	end  
 
	describe "when updating the vlan in serviceprofile - scenario1" do     
		it "should be able to change the state to up" do
			update_vlan_service_profile1.provider.create
		end
	end

	describe "when updating the vlan in serviceprofile - scenario2" do
		it "should be able to change power state to down" do
			update_vlan_service_profile2.provider.create
		end
	end
	
 end