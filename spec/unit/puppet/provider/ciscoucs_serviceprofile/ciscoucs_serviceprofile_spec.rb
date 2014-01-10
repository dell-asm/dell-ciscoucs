require 'spec_helper'
require 'rspec/mocks'
require 'pathname'
require 'rexml/document'

require 'fixtures/unit/puppet/provider/ciscoucs_serviceprofile/ciscoucs_serviceprofile_fixture'


describe Puppet::Type.type(:ciscoucs_serviceprofile).provider(:default) do

  before(:each) do
    @fixture = Ciscoucs_serviceprofile_poweron_fixture.new
    mock_transport=double('transport')
    @fixture.provider.transport = mock_transport
  
    Puppet.stub(:debug)
  end

  context "when brocade config provider is created " do
    it "should have create method defined for ciscoucs_serviceprofile" do
      @fixture.provider.class.instance_method(:create).should_not == nil
    end

    it "should have destroy method defined for ciscoucs_serviceprofile" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for ciscoucs_serviceprofile" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil
    end

    it "should have parent 'Puppet::Provider::Brocade_fos'" do
      @fixture.provider.should be_kind_of(Puppet::Provider::Brocade_fos)
    end
  end

 

end