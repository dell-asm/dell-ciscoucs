require 'spec_helper'
describe Puppet::Type.type(:ciscoucs_serviceprofile_bootpolicy) do
  let(:title) { 'ciscoucs_serviceprofile_bootpolicy' }

  context 'should compile with given test params' do
    let(:params) { {
		:ensure   => 'present',
        :bootpolicy_dn   => 'org-root/boot-policy-testbootpolicy',
        :bootpolicy_name   => 'testbootpolicy',
        :bootpolicy_organization   => 'org-root',
		:serviceprofile_dn   => 'org-root/ls-abc',
        :serviceprofile_name   => 'test_profile_clone',
        :serviceprofile_organization   => 'org-root',
      }}
    it do
      expect {
        should compile
      }
    end

  end

  describe "when validating values" do
    describe "validating boot policy dn param" do
	  
	  it "if the boot policy name exist then organization name should not be blank" do
        expect { described_class.new(:ensure => 'present',:bootpolicy_name => 'testbootpolicy', :bootpolicy_organization => '') }.to raise_error Puppet::Error
      end

	  it "if the organization name exist then boot policy name should not be blank" do
        expect { described_class.new(:ensure => 'present', :bootpolicy_organization => 'org-root', :bootpolicy_name => '') }.to raise_error Puppet::Error
      end

      it "should not allow blank boot policy dn if both source boot policy name and boot policy organization name are blank" do
        expect { described_class.new(:bootpolicy_dn => '', :ensure => 'present',:bootpolicy_name => '', :bootpolicy_organization => '') }.to raise_error Puppet::Error
      end
    end


	describe "validating profile dn param" do

	  it "if the service profile name exist then organization name should not be blank" do
        expect { described_class.new(:ensure => 'present',:serviceprofile_name => 'testbootpolicy', :serviceprofile_organization => '') }.to raise_error Puppet::Error
      end

	  it "if the organization name exist then service profile name should not be blank" do
        expect { described_class.new(:ensure => 'present', :serviceprofile_organization => 'org-root', :serviceprofile_name => '') }.to raise_error Puppet::Error
      end
	  
      it "should not allow blank service profile dn if both serviceprofile name and Organization name are blank" do
        expect { described_class.new(:serviceprofile_dn => '', :ensure => 'present',:serviceprofile_name => '', :serviceprofile_organization => '') }.to raise_error Puppet::Error
      end
    end

   describe "validating member param format" do
		it "should not allow special characters in the service profile dn" do
			expect { described_class.new(:serviceprofile_dn => '$%^&!') }.to raise_error Puppet::Error
		end

		it "should not allow special characters in the service profile name" do
			expect { described_class.new(:serviceprofile_name => '$%^&!') }.to raise_error Puppet::Error
		end

	  	it "should not allow special characters in the service profile organization" do
			expect { described_class.new(:serviceprofile_organization => '$%^&!') }.to raise_error Puppet::Error
		end

		it "should not allow special characters in the boot policy dn" do
			expect { described_class.new(:bootpolicy_dn => '$%^&!') }.to raise_error Puppet::Error
		end

		it "should not allow special characters in the boot policy name" do
			expect { described_class.new(:bootpolicy_name => '$%^&!') }.to raise_error Puppet::Error
		end

	  	it "should not allow special characters in the boot policy organization" do
			expect { described_class.new(:bootpolicy_organization => '$%^&!') }.to raise_error Puppet::Error
		end
      end

end
end
