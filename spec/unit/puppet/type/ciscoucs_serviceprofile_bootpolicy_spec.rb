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
      it "should allow a valid boot policy dn " do
        described_class.new(:ensure => 'present',:bootpolicy_name => '', :bootpolicy_organization => '')[:bootpolicy_dn].should_not == nil
      end
	  
      it "should not allow blank boot policy dn if both source boot policy name and boot policy organization name are blank" do
        expect { described_class.new(:bootpolicy_dn => '', :ensure => 'present',:bootpolicy_name => '', :bootpolicy_organization => '') }.to raise_error Puppet::Error
      end

	  it "should not allow special characters in the source profile dn" do
        expect { described_class.new(:bootpolicy_dn => '$%^&!') }.to raise_error Puppet::Error
      end
    end


	describe "validating profile dn param" do
      it "should allow a valid  profile dn " do
        described_class.new( :ensure => 'present',:serviceprofile_name => '', :serviceprofile_organization => '')[:serviceprofile_dn].should_not == nil
      end
	  
      it "should not allow blank service profile dn if both serviceprofile name and Organization name are blank" do
        expect { described_class.new(:serviceprofile_dn => '', :ensure => 'present',:serviceprofile_name => '', :serviceprofile_organization => '') }.to raise_error Puppet::Error
      end

	  it "should not allow special characters in the source profile dn" do
        expect { described_class.new(:serviceprofile_dn => '$%^&!') }.to raise_error Puppet::Error
      end
    end

end
end
