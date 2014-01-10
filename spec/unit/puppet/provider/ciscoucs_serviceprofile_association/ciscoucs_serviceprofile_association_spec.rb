require 'spec_helper'
require 'rspec/mocks'
require 'pathname'
require 'rexml/document'
require 'fixtures/unit/puppet/provider/ciscoucs_serviceprofile_association/ciscoucs_serviceprofile_association_fixture'

describe Puppet::Type.type(:ciscoucs_serviceprofile_association).provider(:default) do

  before(:each) do
    @fixture = Ciscoucs_serviceprofile_association_fixture.new
    #mock_transport=double('transport')
    #@fixture.provider.transport = mock_transport

    Puppet.stub(:debug)
  end

  context "when ciscoucs_serviceprofile_association configuration provider is created " do

    it "should have create method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:create).should_not == nil
    end

    it "should have destroy method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:exists?).should_not == nil
    end

    it "should have server_dn_name method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:server_dn_name).should_not == nil
    end

    it "should have profile_dn_name method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:profile_dn_name).should_not == nil
    end

    it "should have check_server_already_associated method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:check_server_already_associated).should_not == nil
    end

    it "should have check_operation_state_till_associate_completion method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:check_operation_state_till_associate_completion).should_not == nil
    end

    it "should have check_operation_state_till_dissociate_completion method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:check_operation_state_till_dissociate_completion).should_not == nil
    end

    it "should have call_for_current_state method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:call_for_current_state).should_not == nil
    end

    it "should have parseState method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:parseState).should_not == nil
    end

    it "should have parse_associated_service_profile method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:parse_associated_service_profile).should_not == nil
    end

    it "should have parse_error_code method defined for ciscoucs_serviceprofile_association" do
      @fixture.provider.class.instance_method(:parse_error_code).should_not == nil
    end
  end

end