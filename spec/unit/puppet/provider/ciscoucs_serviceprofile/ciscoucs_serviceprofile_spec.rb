require 'spec_helper'
require 'rspec/mocks'
require 'pathname'
require 'rexml/document'

require 'fixtures/unit/puppet/provider/ciscoucs_serviceprofile/ciscoucs_serviceprofile_fixture'


describe Puppet::Type.type(:ciscoucs_serviceprofile).provider(:default) do

  before(:each) do
    @fixture = Ciscoucs_serviceprofile_poweron_fixture.new
   # mock_transport=double('transport')
   # @fixture.provider.transport = mock_transport
  
    Puppet.stub(:debug)
  end

  context "when ciscoucs service profile provider is created " do
   
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
         @fixture.provider.class.instance_method(:create_profile_from_server).should_not == nil
    end
    
    it "should have create_profile_from_template method defined for ciscoucs_serviceprofile" do
            @fixture.provider.class.instance_method(:create_profile_from_template).should_not == nil
    end
       
    it "should have dn method defined for ciscoucs_serviceprofile" do
               @fixture.provider.class.instance_method(:dn).should_not == nil
    end
    
    it "should have power_dn method defined for ciscoucs_serviceprofile" do
               @fixture.provider.class.instance_method(:power_dn).should_not == nil
    end
    
    it "should have power_state method defined for ciscoucs_serviceprofile" do
               @fixture.provider.class.instance_method(:power_state).should_not == nil
    end
    
    it "should have current_power_state method defined for ciscoucs_serviceprofile" do
                   @fixture.provider.class.instance_method(:current_power_state).should_not == nil
    end

  end


end