require 'spec_helper'
describe Puppet::Type.type(:ciscoucs_serviceprofile_clone) do
  let(:title) { 'ciscoucs_serviceprofile_clone' }

  context 'should compile with given test params' do
    let(:params) { {
		:ensure   => 'present',
        :source_profile_dn   => '',
        :target_profile_dn   => '',
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
    describe "validating source profile dn param" do
      it "should allow a valid source profile dn " do
        described_class.new(:source_profile_dn => '', :ensure => 'present',:source_serviceprofile_name => 'test_profile', :source_organization => 'org-root')[:source_profile_dn].should == ''
      end
	  
      it "should not allow blank service profile dn if both source serviceprofile name and source organization name are blank" do
        expect { described_class.new(:source_profile_dn => '', :ensure => 'present',:source_serviceprofile_name => '', :source_organization => '') }.to raise_error Puppet::Error
      end

	  it "should not allow special characters in the source profile dn" do
        expect { described_class.new(:source_profile_dn => '$%^&!') }.to raise_error Puppet::Error
      end
    end


	describe "validating target profile dn param" do
      it "should allow a valid target profile dn " do
        described_class.new(:target_profile_dn => '', :ensure => 'present',:target_serviceprofile_name => 'test_profile', :target_organization => 'org-root')[:target_profile_dn].should == ''
      end
	  
      it "should not allow blank service profile dn if both target serviceprofile name and target Organization name are blank" do
        expect { described_class.new(:target_profile_dn => '', :ensure => 'present',:target_serviceprofile_name => '', :target_organization => '') }.to raise_error Puppet::Error
      end

	  it "should not allow special characters in the source profile dn" do
        expect { described_class.new(:target_profile_dn => '$%^&!') }.to raise_error Puppet::Error
      end
    end

end
end
