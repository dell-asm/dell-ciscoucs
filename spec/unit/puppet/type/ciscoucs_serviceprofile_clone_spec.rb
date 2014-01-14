require 'spec_helper'
describe Puppet::Type.type(:ciscoucs_serviceprofile_clone) do
  let(:title) { 'ciscoucs_serviceprofile_clone' }

  context 'should compile with given test params' do
    let(:params) { {
		:ensure   => 'present',
        :source_profile_dn   => 'org-root/test_profile',
        :target_profile_dn   => 'org-root/test_profile_clone',
        :source_serviceprofile_name   => 'test_profile',
		:source_organization   => 'org-root',
        :target_serviceprofile_name   => 'test_profile_clone',
        :target_organization   => 'org-root',
      }}
    it do
      expect {
        should compile
      }
    end

  end

  describe "when validating values" do
	describe "validating source service profile dn param" do

	  it "if the service profile name exist then organization name should not be blank" do
        expect { described_class.new(:ensure => 'present',:source_serviceprofile_name => 'test', :source_organization => '') }.to raise_error Puppet::Error
      end

	  it "if the organization name exist then service profile name should not be blank" do
        expect { described_class.new(:ensure => 'present', :source_organization => 'org-root', :source_serviceprofile_name => '') }.to raise_error Puppet::Error
      end
	  
      it "should not allow blank service profile dn if both serviceprofile name and Organization name are blank" do
        expect { described_class.new(:source_profile_dn => '', :ensure => 'present',:source_serviceprofile_name => '', :source_organization => '') }.to raise_error Puppet::Error
      end
    end

	describe "validating profile dn param" do

	  it "if the service profile name exist then organization name should not be blank" do
        expect { described_class.new(:ensure => 'present',:target_serviceprofile_name => 'test', :target_organization => '') }.to raise_error Puppet::Error
      end

	  it "if the organization name exist then service profile name should not be blank" do
        expect { described_class.new(:ensure => 'present', :target_organization => 'org-root', :target_serviceprofile_name => '') }.to raise_error Puppet::Error
      end
	  
      it "should not allow blank service profile dn if both serviceprofile name and Organization name are blank" do
        expect { described_class.new(:target_profile_dn => '', :ensure => 'present',:target_serviceprofile_name => '', :target_organization => '') }.to raise_error Puppet::Error
      end
    end

	describe "validating member param format" do
		it "should not allow special characters in the source service profile dn" do
			expect { described_class.new(:source_profile_dn => '$%^&!') }.to raise_error Puppet::Error
		end

		it "should not allow special characters in the source service profile name" do
			expect { described_class.new(:source_serviceprofile_name => '$%^&!') }.to raise_error Puppet::Error
		end

	  	it "should not allow special characters in the source service profile organization" do
			expect { described_class.new(:source_organization => '$%^&!') }.to raise_error Puppet::Error
		end

		it "should not allow special characters in the target dn" do
			expect { described_class.new(:target_profile_dn => '$%^&!') }.to raise_error Puppet::Error
		end

		it "should not allow special characters in the target name" do
			expect { described_class.new(:target_serviceprofile_name => '$%^&!') }.to raise_error Puppet::Error
		end

	  	it "should not allow special characters in the target organization" do
			expect { described_class.new(:target_organization => '$%^&!') }.to raise_error Puppet::Error
		end
      end

end
end
