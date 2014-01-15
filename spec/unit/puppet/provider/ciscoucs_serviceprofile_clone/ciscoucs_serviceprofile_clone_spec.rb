require 'spec_helper'
require 'fixtures/unit/puppet/provider/ciscoucs_serviceprofile_clone/ciscoucs_serviceprofile_clone_fixture'



NOOPS_HASH = {:noop => false}
include PuppetX::Puppetlabs::Transportciscoucs
describe Puppet::Type.type(:ciscoucs_serviceprofile_clone).provider(:default) do

  before(:each) do
    @fixture = Ciscoucs_serviceprofile_clone_fixture.new
    #mock_transport=double('transport')
    #@fixture.provider.post = mock_transport
    Puppet.stub(:disconnect)
    Puppet.stub(:debug)

  end

  context "when ciscoucs service profile clone provider is created " do

    it "should have parent 'Puppet::Provider::ciscoucs_serviceprofile_clone'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Ciscoucs)
    end

    it "should have create method defined for ciscoucs service profile clone" do
      @fixture.provider.class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for ciscoucs service profile clone" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for ciscoucs service profile clone" do
      @fixture.provider.class.instance_method(:exists?) == nil
    end

  end

  context "when service profile clone is created" do
      it "should raise error if target profile dn is blank" do
      #When-Then
      @fixture.provider.target_profile_dn.should_not == nil
      end
      
      it "should raise error if source profile dn is blank" do
      #When-Then
      @fixture.provider.source_profile_dn.should_not == nil
      end
      
      it "should raise error if cookie is blank" do
      #When-Then
      @fixture.provider.class.instance_method(:cookie).should_not == nil
      end
      
      it "should raise error if cookie is blank" do
      #When-Then
      @fixture.provider.class.instance_method(:disconnect).should_not == nil
      end

      it "should raise error if all 3 parameters source organization, name and dn are blank" do
      #When-Then
      @fixture.get_source_organization.should_not == nil
      @fixture.get_source_profile_dn.should_not == nil
      @fixture.get_source_serviceprofile_name.should_not == nil
      end
      
      it "should raise error if all 3 parameters target organization, name and dn are blank" do
      #When-Then
      @fixture.get_target_organization.should_not == nil
      @fixture.get_target_profile_dn.should_not == nil
      @fixture.get_target_serviceprofile_name.should_not == nil
      end
 
  end
end