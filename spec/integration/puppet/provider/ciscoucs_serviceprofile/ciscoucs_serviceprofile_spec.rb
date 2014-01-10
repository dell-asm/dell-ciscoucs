#! /usr/bin/env ruby

require 'spec_helper'

require 'yaml'
require 'puppet/provider/cisoucs'
require 'rbvmomi'
require 'puppet_x/puppetlabs/transport/ciscoucs'
#require 'Puppet_x'
#require 'puppet/resource'

describe Puppet::Type.type(:ciscoucs_serviceprofile).provider(:ciscoucs_serviceprofile) do

  # device_conf =  YAML.load_file(my_deviceurl('equallogic','device_conf.yml'))
    before :each do
    #Facter.stubs(:value).with(:url).returns(device_conf['url'])
	#Facter.stubs(:value).with(:url).returns(Transport['vcenter'])
	  described_class.stubs(:suitable?).returns true
      Puppet::Type.type(:ciscoucs_serviceprofile).stubs(:defaultprovider).returns described_class
    end

  ciscoucs_serviceprofile_yml =  YAML.load_file(my_fixture('ciscoucs_serviceprofile.yml'))
  poweron = ciscoucs_serviceprofile_yml['poweron']  
  
  transport_yml =  YAML.load_file(my_fixture('transport.yml'))
  transport_node = transport_yml['transport']
  
  params = {:name => 'vcenter', :username => 'admin', :password => 'admin', :server => '192.168.199.131'} 
  providers = 'ciscoucs'
  let :power_on do
	Puppet::Type.type(:transport).new(
	    :name               => transport_node['name'],
	    :username               => transport_node['username'],
		:password             => transport_node['password'],		
		:server             => transport_node['server']
				
    )	 

    transportx = PuppetX::Puppetlabs::Transport::const_get(providers.to_s.capitalize).new(params)
	  transportx.connect 
	
	Puppet::Type.type(:ciscoucs_serviceprofile).new(
	  :serviceprofile_name               => poweron['serviceprofile_name'],
		:organization             => poweron['organization'],
		:transport          => transportx,
		:profile_dn             => poweron['profile_dn'],
		:power_state         => poweron['power_state']
		  
    )
  end  

  poweroff = ciscoucs_serviceprofile_yml['poweroff']
  
  let :power_off do
    Puppet::Type.type(:ciscoucs_serviceprofile).new(
    :name               => transport_node['name'],
    :username               => transport_node['username'],
    :password             => transport_node['password'],    
    :server             => transport_node['server']
    )
    transportx = PuppetX::Puppetlabs::Transport::const_get(providers.to_s.capitalize).new(params)
       transportx.connect 
     
     Puppet::Type.type(:ciscoucs_serviceprofile).new(
       :serviceprofile_name               => poweroff['serviceprofile_name'],
       :organization             => poweroff['organization'],
       :transport          => transportx,
       :profile_dn             => poweroff['profile_dn'],
       :power_state         => poweroff['power_state']
         
       )
     end   
	
  
 
  let :provider do
    described_class.new( )
  end

  # describe "when asking exists?" do
    # it "should return true if resource/vm is present" do
      # power_on.provider.set(:ensure => :present)
      # power_on.provider.should be_exists
    # end

    # it "while removing vm - should return false if resource/vm is absent" do
      # power_off.provider.set(:ensure => :absent)
      # power_off.provider.should_not be_exists
    # end
   # end


  describe "when registering a vm" do
    
    it "should be able to register vm" do
	puts "inside create"  
      power_on.provider.create
    end
  end

  # describe "when creating a new volume - with name already exists" do
    # it "should not be allowed to create a volume with duplicate name" do
      # create_volume.provider.create
    # end
  # end


  # describe "when creating a volume with 1k size - it should fail" do
    # it "should not be allowed  to create a volume with 1k size" do
      # create_volume_oneK.provider.create
    # end
  # end

   describe "when removing a vm - which already exists" do
    it "should be able to remove vm" do
      #power_off.provider.destroy
    end
  end

  # describe "when destroying a volume which non existant" do
    # it "destroy should not be successful if volume does not exists" do
      # destroy_volume_Non.provider.destroy
    # end
  # end

  # describe "when changing state of volume from offline to online" do
    # it "change state of volume from offline to online" do
	# online_to_offline.provider.state='offline'
    # end
  # end

  # describe "when changing state of volume from offline to online" do
    # it "change state of volume from offline to online" do
        # offline_to_online.provider.state='online'
    # end
  # end
  
  # describe "when changing state of volume from offline to online" do
    # it "change state of volume from offline to online" do
	# enable_multihostaccess.provider.multihostaccess=''
    # end
  # end

  # describe "when changing state of volume from offline to online" do
    # it "change state of volume from offline to online" do
        # disable_multihostaccess.provider.multihostaccess=''
    # end
  # end

end
