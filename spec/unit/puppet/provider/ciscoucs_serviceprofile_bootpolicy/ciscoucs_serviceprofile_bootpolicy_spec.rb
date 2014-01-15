require 'spec_helper'
require 'fixtures/unit/puppet/provider/ciscoucs_serviceprofile_bootpolicy/ciscoucs_serviceprofile_bootpolicy_fixture'

NOOPS_HASH = {:noop => false}
include PuppetX::Puppetlabs::Transportciscoucs
describe Puppet::Type.type(:ciscoucs_serviceprofile_bootpolicy).provider(:default) do

  before(:each) do
    @fixture = Ciscoucs_serviceprofile_bootpolicy_fixture.new
    Puppet.stub(:disconnect)
    Puppet.stub(:debug)

  end

  context "when ciscoucs boot policy is applied to the service profile" do

    it "should have parent 'Puppet::Provider::ciscoucs_serviceprofile_bootpolicy'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Ciscoucs)
    end

    it "should have create method defined for ciscoucs boot policy" do
      @fixture.provider.class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for ciscoucs boot policy" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for ciscoucs boot policy" do
      @fixture.provider.class.instance_method(:exists?) == nil
    end

  end

  context "when boot policy is applied to the service profile" do
      it "should raise error if policy dn is blank" do
      #When-Then
      @fixture.provider.boot_policy_dn.should_not == nil
      end
      
      it "should raise error if source profile dn is blank" do
      #When-Then
      @fixture.provider.service_profile_dn.should_not == nil
      end
      
      it "should raise error if cookie is blank" do
      #When-Then
      @fixture.provider.class.instance_method(:cookie).should_not == nil
      end
      
      it "should raise error if disconnect method is not present" do
      #When-Then
      @fixture.provider.class.instance_method(:disconnect).should_not == nil
      end

      it "should raise error if all 3 parameters source organization, name and dn are blank" do
      #When-Then
      @fixture.get_serviceprofile_organization.should_not == nil
      @fixture.get_serviceprofile_dn.should_not == nil
      @fixture.get_serviceprofile_name.should_not == nil
      end
      
      it "should raise error if all 3 parameters target organization, name and dn are blank" do
      #When-Then
      @fixture.get_bootpolicy_organization.should_not == nil 
      @fixture.get_bootpolicy_dn.should_not == nil
      @fixture.get_bootpolicy_name.should_not == nil
      end
 
  end
end