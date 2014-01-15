require 'spec_helper'

describe Puppet::Type.type(:ciscoucs_vlan) do
  let(:title) { 'ciscoucs_vlan' }
  
 context 'should compile with given test params for vlan creation' do
    let(:params) { {
        :ensure => 'present',
        :vlan_name   => 'myvlan',
        :vlanid   => '10',
        :fabric_id   => 'A',
    		:mcast_policy_name    => 'mpolicy',
    		:sharing   => 'none',
    		:status    => 'created',
		
      }}
      
    it do
      expect {
        should compile
      }
    end

  end
  
  context "when validating attributes" do
    it "should have vlan_name as one of its parameters for creating vlan" do
      described_class.key_attributes.should == [:vlan_name]
    end
        
    it "should have vlanid as one of its parameters for creating vlan" do
      described_class.key_attributes.should == [:vlanid]
    end 
    

    it "should not allow ensure to be blank" do
        expect { described_class.new(:ensure => '', :vlan_id => '10', :fabric_id => 'A', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')}.to raise_error Puppet::Error
    end
    
    
    it "should not allow ensure to be invalid" do
       expect { described_class.new(:ensure => '$@$%#%', :vlan_id => '10', :fabric_id => 'A', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')}.to raise_error Puppet::Error
    end
    
    it "should not allow vlan_name to be blank" do
        expect { described_class.new(:ensure => 'present', :vlan_id => '10', :fabric_id => 'A', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')}.to raise_error Puppet::Error
    end
    
    it "should not allow blank value in the  organization" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => '', :name => 'testing',:vlan_name => 'myvlan', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end
  
    it "should not allow vlan_name to be nil" do
      described_class.new(:ensure => 'present',:vlan_id => '10', :fabric_id => 'A', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')[:vlan_name].should_not == nil
    end
    
    it "should not allow sharing to be nil" do
      described_class.new(:ensure => 'present',:vlan_id => '10', :fabric_id => 'A', :mcast_policy_name => 'mpolicy' , :vlan_name => 'myvlan', :status => 'created')[:sharing].should_not == nil
    end 
    
    it "should not allow vlanid to be nil" do
        described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :fabric_id => 'A', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')[:vlanid].should_not == nil
    end
    
    it "should not allow status to be nil" do
      described_class.new(:ensure => 'present',:vlan_id => '10', :fabric_id => 'A', :mcast_policy_name => 'mpolicy' , :vlan_name => 'myvlan', :sharing => 'none')[:status].should_not == nil
    end 
    
    it "should not allow invalid value in mcast_policy_name" do
    described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :sharing => 'none', :status => 'created')[:mcast_policy_name].should == '@#$%'
    end
    
    it "should not allow invalid value in mcast_policy_name" do
    expect { described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :sharing => 'none', :mcast_policy_name => '@#$%', :status => 'created') }.to raise_error Puppet::Error
     end  
    
    it "should not allow invalid value in sharing" do
    expect { described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :sharing => '@#$%', :mcast_policy_name => mcastpolicy, :status => 'created') }.to raise_error Puppet::Error
    end 
    
    it "should not allow invalid value in status" do
    expect { described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :sharing => 'none', :mcast_policy_name => 'mcastpolicy', :status => '@#$%') }.to raise_error Puppet::Error
    end 
    
    it "should not allow invalid value in fabric_id" do
    expect { described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => '@#$%' , :sharing => 'none', :mcast_policy_name => 'mcast', :status => 'created') }.to raise_error Puppet::Error
    end 
    
    it "should not allow invalid value in vlanid" do
    expect { described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '@#$%', :fabric_id => 'A' , :sharing => 'none', :mcast_policy_name => 'mcast', :status => 'created') }.to raise_error Puppet::Error
    end
    
    it "should not allow invalid value in vlan_name" do
    expect { described_class.new(:ensure => 'present',:vlan_name => '@#$%', :vlanid => '10', :fabric_id => 'A' , :sharing => 'none', :mcast_policy_name => 'mcast', :status => 'created') }.to raise_error Puppet::Error
    end 
  end

  describe "validating possible values" do
    it "fabric_id should support A" do
      described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')[:fabric_id].should == :A
    end
  
    it "fabric_id should support B" do
        described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')[:fabric_id].should == :B
      end
  
    it "fabric_id should support blank value" do
        described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :mcast_policy_name => 'mpolicy' , :sharing => 'none', :status => 'created')[:fabric_id].should == ''
    end
   
    it "mcast_policy_name should support blank value" do
      described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :sharing => 'none', :status => 'created')[:mcast_policy_name].should == ''
      end
      
    it "sharing should support none as a value" do
      described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :mcast_policy_name => 'mcast', :status => 'created')[:sharing].should == 'none'
    end
    
    it "sharing should support primary as a value" do
     described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :mcast_policy_name => 'mcast', :status => 'created')[:sharing].should == 'primary'
   end

    it "status should support created as a value" do
      described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :mcast_policy_name => 'mcast', :sharing => 'none')[:status].should == 'created'
    end
    
    it "status should support deleted as a value" do
      described_class.new(:ensure => 'present',:vlan_name => 'myvlan', :vlanid => '10', :fabric_id => 'A' , :mcast_policy_name => 'mcast', :sharing => 'none')[:status].should == 'deleted'
    end
      
    end
  
end
