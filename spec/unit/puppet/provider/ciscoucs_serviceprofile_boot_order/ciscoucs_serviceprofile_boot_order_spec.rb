require 'spec_helper'
require 'fixtures/unit/puppet/provider/ciscoucs_serviceprofile_boot_order/ciscoucs_serviceprofile_boot_order_fixture'

NOOPS_HASH = {:noop => false}
include PuppetX::Puppetlabs::Transportciscoucs
describe Puppet::Type.type(:ciscoucs_serviceprofile_boot_order).provider(:default) do

  before(:each) do
    @fixture = Ciscoucs_serviceprofile_boot_order_fixture.new
    Puppet.stub(:disconnect)
    Puppet.stub(:debug)

  end

  context "when ciscoucs boot policy order is applied to the service profile" do

    it "should have parent 'Puppet::Provider::ciscoucs_serviceprofile_boot_order'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Ciscoucs)
    end

    it "should have create method defined for ciscoucs boot policy order" do
      @fixture.provider.class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for ciscoucs boot policy order" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for ciscoucs boot policy order" do
      @fixture.provider.class.instance_method(:exists?) == nil
    end

  end

  context "when boot policy is applied to the service profile" do
      it "should raise error if policy dn is blank" do
      #When-Then
      @fixture.provider.boot_policy_dn.should_not == nil
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
      end
      
      it "should raise error if cookie is blank" do
      #When-Then
      @fixture.provider.class.instance_method(:cookie).should_not == nil
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
      end
      
      it "should raise error if disconnect method is not present" do
      #When-Then
      @fixture.provider.class.instance_method(:disconnect).should_not == nil
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
      end
      
      it "should raise error if all 3 parameters boot policy organization, name and dn are blank" do
      #When-Then
      @fixture.get_organization.strip.length == 0 
      @fixture.get_bootpolicy_dn.strip.length == 0
      @fixture.get_bootpolicy_name.strip.length == 0
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
      end

	  it "should raise error if all 3 parameters boot policy lan order is blank" do
      #When-Then
      @fixture.get_lan_order.strip.length == 0 
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
      end

	  it "should raise error if xml template and xml template path in the provider are blank" do
      #When-Then
      @fixture.provider.xml_template.strip.length == 0 
	  @fixture.provider.xml_template_path.strip.length == 0 
      expect {@fixture.provider.create}.to raise_error(Puppet::Error)
      end
 
  end
end