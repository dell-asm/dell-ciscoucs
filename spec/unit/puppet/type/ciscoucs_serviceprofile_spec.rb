require 'spec_helper'

describe Puppet::Type.type(:ciscoucs_serviceprofile) do
  let(:title) { 'ciscoucs_serviceprofile' }

  context 'should compile with given test params' do
    let(:params) { {
        :organization   => 'org-root',
        :serviceprofile_name   => 'testServiceProfile',
        :power_state   => 'up',
      }}
    it do
      expect {
        should compile
      }
    end

  end

  context "when validating attributes" do
    it "should have serviceprofile_name as one of its parameters for serviceprofile" do
      described_class.key_attributes.should == [:serviceprofile_name]
    end
    
    describe "when validating power_state property" do
      it "should support up" do
        described_class.new(:organization => 'org-root', :serviceprofile_name => 'testServiceProfile', :power_state => 'up')[:power_state].should == :up
      end

      it "should support down" do
        described_class.new(:organization => 'org-root', :serviceprofile_name => 'testServiceProfile', :power_state => 'down')[:power_state].should == :down
      end

    end
  end
  
end
