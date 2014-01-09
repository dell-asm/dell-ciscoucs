require 'spec_helper'
describe Puppet::Type.type(:ciscoucs_serviceprofile_boot_order) do
  let(:title) { 'ciscoucs_serviceprofile_boot_order' }

  context 'should compile with given test params' do
    let(:params) { {
		:ensure   => 'present',
        :bootpolicy_dn   => 'org-root/boot-policy-testbootpolicy',
        :bootpolicy_name   => 'testbootpolicy',
        :organization   => 'org-root',
		:lan_order   => '5',
      }}
    it do
      expect {
        should compile
      }
    end

  end

  describe "when validating values" do
    describe "validating source profile dn param" do
      it "if the boot policy name exist then organization name should not be blank" do
        expect { described_class.new(:ensure => 'present',:bootpolicy_name => 'testbootpolicy', :organization => '') }.to raise_error Puppet::Error
      end

	  it "if the organization name exist then boot policy name should not be blank" do
        expect { described_class.new(:ensure => 'present', :organization => 'org-root', :bootpolicy_name => '') }.to raise_error Puppet::Error
      end
	  
      it "should not allow blank service profile dn if both serviceprofile name and organization name are blank" do
        expect { described_class.new(:bootpolicy_dn => '', :ensure => 'present',:bootpolicy_name => '', :organization => '') }.to raise_error Puppet::Error
      end
    end

	 describe "validating member param" do
        it "should allow a valid lan_order format" do
          described_class.new(:ensure => 'present', :bootpolicy_name => 'testbootpolicy', :organization => 'org-root')[:lan_order].should_not == nil
        end

	   it "should allow a valid lan_order format" do
          described_class.new(:ensure => 'present', :bootpolicy_name => '', :organization => '', :bootpolicy_dn   => 'org-root/boot-policy-testbootpolicy')[:lan_order].should_not == nil
        end

        it "should not allow special char in the lan order value" do
          expect { described_class.new(:ensure => 'present', :bootpolicy_name => '', :organization => '', :bootpolicy_dn   => 'org-root/boot-policy-testbootpolicy', :lan_order => 'a%bc') }.to raise_error Puppet::Error
        end

		it "should not allow special characters in the bootpolicy name" do
			expect { described_class.new(:bootpolicy_name => '$%^&!') }.to raise_error Puppet::Error
		end

		it "should not allow special characters in the organization name" do
			expect { described_class.new(:organization => '$%^&!') }.to raise_error Puppet::Error
		end

	  	it "should not allow special characters in the bootpolicy dn" do
			expect { described_class.new(:bootpolicy_dn => '$%^&!') }.to raise_error Puppet::Error
		end
      end

end
end
