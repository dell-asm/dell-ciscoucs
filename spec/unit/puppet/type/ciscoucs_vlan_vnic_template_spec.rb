require 'spec_helper'

describe Puppet::Type.type(:ciscoucs_vlan_template) do
  let(:title) { 'ciscoucs_vlan_template' }
  
 context 'should compile with given test params for vlan creation' do
    let(:params) { {
        :ensure => 'present',
        :name   => 'serviceprofile',
        :vlan_name   => 'myvlan',
        :vnictemplateorg   => 'org-root',
        :vnic    => 'vnic1',
        :defaultnet   => 'no',
       
    
      }}
      
    it do
      expect {
        should compile
      }
    end

  end

  context "when validating attributes" do
    
    it "should have vlan_name as one of its parameters " do
          described_class.key_attributes.should == [:vlan_name]
    end
        
    it "should have service profile name as one of its parameters " do
        described_class.key_attributes.should == [:name]
    end
    
    it "should have vnictemplateorg as one of its parameters " do
        described_class.key_attributes.should == [:vnictemplateorg]
    end 
    
    it "should have vnic as one of its parameters " do
            described_class.key_attributes.should == [:vnic]
    end 
        
    it "should have defaultnet as one of its parameters" do
            described_class.key_attributes.should == [:defaultnet]
    end 
    
    it "should not allow blank value in the  organization" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => '', :name => 'testing',:vlan_name => 'myvlan', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end

    it "should not allow invalid value in the  organization" do
          expect { described_class.new(:ensure => 'present', :vnictemplateorg => '@#$', :name => 'testing',:vlan_name => 'myvlan', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
        end
        
    it "should not allow blank value in the  vnic" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => '',:vlan_name => 'myvlan', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end
    
    it "should not allow invalid value in the  vnic" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => '$^$$^%',:vlan_name => 'myvlan', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end
     
    it "should not allow blank value in the  defaultnet" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => 'testing',:vlan_name => 'myvlan', :defaultnet => '', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end
        
    it "should not allow invalid value in the  defaultnet" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => 'testing',:vlan_name => 'myvlan', :defaultnet => '#%$#%', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end
        
    it "should not allow blank value in the name" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => '',:vlan_name => 'myvlan', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end
        
    it "should not allow invalid vnic in the  name" do
      expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => 'testing',:vlan_name => 'myvlan', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end 
    
    it "should not allow blank value in the vlan_name" do
     expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => '^testing',:vlan_name => '', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
   end
       
   it "should not allow invalid vnic in the  vlan_name" do
     expect { described_class.new(:ensure => 'present', :vnictemplateorg => 'org-root', :name => 'testing',:vlan_name => '!@##&', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
   end 
   
    it "should not allow invalid value in the  ensure" do
      expect { described_class.new(:ensure => '!@#$%', :vnictemplateorg => 'org-root', :name => 'testing',:vlan_name => '!@##&', :defaultnet => 'no', :vnic => 'vnic1') }.to raise_error Puppet::Error
    end
                

end
end
