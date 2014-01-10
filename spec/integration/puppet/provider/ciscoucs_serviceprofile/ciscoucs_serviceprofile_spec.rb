#! /usr/bin/env ruby

require 'spec_helper'

require 'yaml'
require 'puppet/provider/ciscoucs'
require 'rbvmomi'
require 'puppet_x/puppetlabs/transport/ciscoucs'
#require 'Puppet_x'
#require 'puppet/resource'

describe Puppet::Type.type(:ciscoucs_serviceprofile).provider(:default) do

  # device_conf =  YAML.load_file(my_deviceurl('equallogic','device_conf.yml'))
    before :each do
    #Facter.stubs(:value).with(:url).returns(device_conf['url'])
	#Facter.stubs(:value).with(:url).returns(Transport['vcenter'])
	  described_class.stubs(:suitable?).returns true
      Puppet::Type.type(:ciscoucs_serviceprofile).stubs(:defaultprovider).returns described_class
    end

  ciscoucs_serviceprofile_yml =  YAML.load_file(my_fixture('ciscoucs_serviceprofile.yml'))
  power_on = ciscoucs_serviceprofile_yml['power_on']  
  
  transport_yml =  YAML.load_file(my_fixture('transport.yml'))
  transport_node = transport_yml['transport']
  
  params = {:name => 'ciscoucs', :username => 'admin', :password => 'admin', :server => '172.16.100.167'} 
  providers = 'ciscoucs'
  let :ciscoucs_poweron do
	Puppet::Type.type(:transport).new(
	  :name               => transport_node['name'],
	  :username               => transport_node['username'],
		:password             => transport_node['password'],		
		:server             => transport_node['server']
			
    )	 

    transportx = PuppetX::Puppetlabs::Transport::const_get(providers.to_s.capitalize).new(params)
	transportx.connect 
	
	Puppet::Type.type(:ciscoucs_serviceprofile).new(
	  :serviceprofile_name    => power_on['serviceprofile_name'],
		:organization     => power_on['organization'],
		:transport        => transportx,
		:power_state             => power_on['power_state']
		 
    )
  end  

  power_off = ciscoucs_serviceprofile_yml['power_off']
  
  let :ciscoucs_poweroff do
    Puppet::Type.type(:transport).new(
        :name               => transport_node['name'],
        :username               => transport_node['username'],
        :password             => transport_node['password'],    
        :server             => transport_node['server']
          
        )  
    
        transportx = PuppetX::Puppetlabs::Transport::const_get(providers.to_s.capitalize).new(params)
      transportx.connect 
      
      Puppet::Type.type(:ciscoucs_serviceprofile).new(
       :serviceprofile_name    => power_off['serviceprofile_name'],
       :organization     => power_off['organization'],
       :transport        => transportx,
       :power_state             => power_off['power_state']
         
        )
      end  

end
