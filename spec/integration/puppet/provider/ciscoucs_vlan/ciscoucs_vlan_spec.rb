#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_vlan).provider(:default) do

   ciscoucs_vlan_create_yml =  YAML.load_file(my_fixture('ciscoucs_vlan.yml'))
   create_vlan = ciscoucs_vlan_create_yml['CiscoUcsVlan1']  
   
   transport_yml =  YAML.load_file('transport.yml')
   transport_node = transport_yml['transport']
  
	let(:ciscoucs_vlan_create) do
		@catalog = Puppet::Resource::Catalog.new
		transport = Puppet::Type.type(:transport).new({
			:name => transport_node['name'],
			:username => transport_node['username'],
			:password => transport_node['password'],
			:server   => transport_node['server'],
		})
		@catalog.add_resource(transport)

		Puppet::Type.type(:ciscoucs_serviceprofile).new(
			:name               => create_vlan['name'],
			:ensure   			=> create_vlan['ensure'],
			:transport          => transport, 
			:catalog            => @catalog,
			:vlanid       		=> create_vlan['vlanid'],
			:mcast_policy_name  => create_vlan['mcast_policy_name'],
			:sharing       		=> create_vlan['sharing'],
			:fabric_id  		=> create_vlan['fabric_id'],
			:status  			=> create_vlan['status'],
		)
	end  
   
	ciscoucs_vlan_destroy_yml =  YAML.load_file(my_fixture('ciscoucs_vlan.yml'))
    destroy_vlan = ciscoucs_vlan_create_yml['CiscoUcsVlan2']
   
	let(:ciscoucs_vlan_destroy) do
		@catalog = Puppet::Resource::Catalog.new
		transport = Puppet::Type.type(:transport).new({
			:name => transport_node['name'],
			:username => transport_node['username'],
			:password => transport_node['password'],
			:server   => transport_node['server'],
		})
	@catalog.add_resource(transport)

		Puppet::Type.type(:ciscoucs_serviceprofile).new(
			:name               => destroy_vlan['name'],
			:ensure   			=> destroy_vlan['ensure'],
			:transport          => transport, 
			:catalog            => @catalog,
			:vlanid       		=> destroy_vlan['vlanid'],
			:mcast_policy_name  => destroy_vlan['mcast_policy_name'],
			:sharing       		=> destroy_vlan['sharing'],
			:fabric_id  		=> destroy_vlan['fabric_id'],
			:status  			=> destroy_vlan['status'],
		)
	end  
 
   describe "should create new vlan - when create new vlan in cisco ucs" do     
     it "should be able to create new vlan" do
       ciscoucs_vlan_create.provider.create
     end
   end
 
   describe "should destroy vlan - when create new vlan in cisco ucs" do
     it "should be able to destroy vlan" do
       ciscoucs_vlan_destroy.provider.destroy
     end
   end
 end