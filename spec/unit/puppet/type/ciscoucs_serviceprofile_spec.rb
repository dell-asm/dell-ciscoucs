require 'spec_helper'

describe Puppet::Type.type(:ciscoucs_serviceprofile) do
  let(:title) { 'ciscoucs_serviceprofile' }

  context 'should compile with given test params' do
    let(:params) { {
        :organization   => 'org-root',
        :serviceprofile_name   => 'testServiceProfile',
        :power_state   => 'up',
		:number_of_profiles    => '1',
		
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
	  
	  it "should not allow invalid value in the serviceprofile_name" do
          expect { described_class.new(:organization => 'org-root', :serviceprofile_name => '@#$%', :power_state => 'down') }.to raise_error Puppet::Error
        end
		it "should not allow invalid value in the organization name" do
          expect { described_class.new(:organization => '@#$%', :serviceprofile_name => 'testServiceProfile', :power_state => 'down') }.to raise_error Puppet::Error
        end
		it "should not allow blank value in the organization name" do
          expect { described_class.new(:organization => '', :serviceprofile_name => 'testServiceProfile', :power_state => 'down') }.to raise_error Puppet::Error
        end
		it "should not allow blank value in the testServiceProfile name" do
          expect { described_class.new(:organization => 'org-root', :serviceprofile_name => '', :power_state => 'down') }.to raise_error Puppet::Error
        end
		it "should allow Number of profiles to be created " do
          expect { described_class.new(:organization => 'org-root', :serviceprofile_name => 'testServiceProfile', :power_state => 'up', :number_of_profiles => 1) }.to raise_error Puppet::Error
     	end
		 it "should not allow number_of_profiles to be nill " do
        described_class.new(:organization => 'org-root', :serviceprofile_name => 'testServiceProfile', :power_state => 'down',:number_of_profiles => '')[:number_of_profiles].should_not == nil
      end
		it "should not allow invalid value in the number_of_profiles " do
          expect { described_class.new(:organization => 'org-root', :serviceprofile_name => 'testServiceProfile', :power_state => 'down',:number_of_profiles => '@#$%') }.to raise_error Puppet::Error
        end	

    end
  end
  
end
