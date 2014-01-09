require 'spec_helper'

describe Puppet::Type.type(:ciscoucs_serviceprofile_association) do
  let(:title) { 'ciscoucs_serviceprofile_association' }

  context 'should compile with given test params for association' do
    let(:params) { {
        :ensure              => 'present',
        :organization        => 'org-root',
        :serviceprofile_name => 'testing',
        :profile_dn          => '',
        :server_chassis_id   => 'chassis-1',
        :server_slot_id      => 'blade-3',
        :server_dn           => '',
      }}
    it do
      expect {
        should compile
      }
    end
  end
  
  context 'should compile with given test params for dissociation' do
      let(:params) { {
          :ensure              => 'absent',
          :organization        => 'org-root',
          :serviceprofile_name => 'testing',
          :profile_dn          => '',
          :server_chassis_id   => 'chassis-1',
          :server_slot_id      => 'blade-3',
          :server_dn           => '',
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
