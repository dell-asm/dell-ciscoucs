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
    
    describe "when validating association call" do
      it "Parameter for association call should be present" do
        described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '')[:ensure].should == :present
      end

      describe "when validating association call" do
            it "Parameter for association call should be absent" do
              described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '')[:ensure].should == :absent
            end
      end
      

      # association 
      
      it "should not allow blank value in the  ensure" do
              expect { described_class.new(:ensure => '@#$%', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow blank value in the  organization" do
              expect { described_class.new(:ensure => 'present', :organization => '@#$%', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  name" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => '@#$%', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  dn" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '@#$%', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  chassis id" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => '@#$%', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow blank value in the  slot id" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => '@#$%', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  server dn" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '@#$%') }.to raise_error Puppet::Error
            end
          
          it "should not allow invalid value in the  ensure" do
              expect { described_class.new(:ensure => '@#$%', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow invalid value in the  organization" do
              expect { described_class.new(:ensure => 'present', :organization => '@#$%', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  name" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => '@#$%', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  dn" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '@#$%', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  chassis id" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => '@#$%', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow invalid value in the  slot id" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => '@#$%', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  server dn" do
              expect { described_class.new(:ensure => 'present', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '@#$%') }.to raise_error Puppet::Error
            end
          
          
          # -------------------- dissociation
          
         # association 
      
      it "should not allow blank value in the  ensure" do
              expect { described_class.new(:ensure => '@#$%', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow blank value in the  organization" do
              expect { described_class.new(:ensure => 'absent', :organization => '@#$%', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  name" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => '@#$%', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  dn" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '@#$%', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  chassis id" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => '@#$%', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow blank value in the  slot id" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => '@#$%', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow blank value in the  server dn" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '@#$%') }.to raise_error Puppet::Error
            end
          
          it "should not allow invalid value in the  ensure" do
              expect { described_class.new(:ensure => '@#$%', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow invalid value in the  organization" do
              expect { described_class.new(:ensure => 'absent', :organization => '@#$%', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  name" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => '@#$%', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  dn" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '@#$%', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  chassis id" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => '@#$%', :server_slot_id => 'blade-3', :server_dn => '') }.to raise_error Puppet::Error
            end
            it "should not allow invalid value in the  slot id" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => '@#$%', :server_dn => '') }.to raise_error Puppet::Error
            end
      
            it "should not allow invalid value in the  server dn" do
              expect { described_class.new(:ensure => 'absent', :organization => 'org-root', :serviceprofile_name => 'testing', :profile_dn => '', :server_chassis_id   => 'chassis-1', :server_slot_id => 'blade-3', :server_dn => '@#$%') }.to raise_error Puppet::Error
            end

    end
  end
  
end
