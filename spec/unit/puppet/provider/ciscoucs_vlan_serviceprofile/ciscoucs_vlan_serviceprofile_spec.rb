#! /usr/bin/env ruby

require 'spec_helper'
require 'rspec/mocks'
require 'pathname'
require 'rexml/document'
require 'fixtures/unit/puppet/provider/ciscoucs_vlan_serviceprofile/ciscoucs_vlan_serviceprofile_fixture'

describe Puppet::Type.type(:ciscoucs_vlan_serviceprofile).provider(:default) do

  before(:each) do
    @fixture = Ciscoucs_vlan_serviceprofile_fixture.new
   # mock_transport=double('transport')
   # @fixture.provider.transport = mock_transport
    Puppet.stub(:debug)
  end

  context "when ciscoucs service profile provider is created " do
   
    it "should have parent 'Puppet::Provider::Ciscoucs'" do
         @fixture.provider.should be_kind_of(Puppet::Provider::Ciscoucs)
       end
   
    it "should have create method defined for ciscoucs_serviceprofile" do
      @fixture.provider.class.instance_method(:create).should_not == nil
    end

    it "should have destroy method defined for ciscoucs_serviceprofile" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for ciscoucs_serviceprofile" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil
    end
    
    it "should have create_profile_from_server method defined for ciscoucs_serviceprofile" do
         @fixture.provider.class.instance_method(:checkvlan).should_not == nil
    end
    
    it "should have create_profile_from_template method defined for ciscoucs_serviceprofile" do
            @fixture.provider.class.instance_method(:checkvnic).should_not == nil
    end

  end
  
  


end