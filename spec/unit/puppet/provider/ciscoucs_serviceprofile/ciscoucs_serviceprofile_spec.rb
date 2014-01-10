require 'spec_helper'
require 'rspec/mocks'
require 'pathname'
require 'rexml/document'

require 'fixtures/unit/puppet/provider/ciscoucs_serviceprofile/ciscoucs_serviceprofile_fixture'

NOOP_HASH = { :noop => false}
ENABLE_PROMPT_HASH = {:prompt => Puppet::Provider::Brocade_messages::CONFIG_ENABLE_PROMPT}
DISABLE_PROMPT_HASH = {:prompt => Puppet::Provider::Brocade_messages::CONFIG_DISABLE_PROMPT}

describe "Ciscoucs_serviceprofile" do

  before(:each) do
    @fixture = Ciscoucs_serviceprofile_fixture.new
    mock_transport=double('transport')
    @fixture.provider.transport = mock_transport
    @fixture.provider.stub(:cfg_save)
    Puppet.stub(:info)
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