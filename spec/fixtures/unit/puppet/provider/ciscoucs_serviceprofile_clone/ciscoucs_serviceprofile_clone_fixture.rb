class Ciscoucs_serviceprofile_clone_fixture
  attr_accessor :ciscoucs_serviceprofile_clone, :provider
  def initialize
    @ciscoucs_serviceprofile_clone = get_ciscoucs_serviceprofile_clone
    @provider = ciscoucs_serviceprofile_clone.provider
  end

  def  get_ciscoucs_serviceprofile_clone
    Puppet::Type.type(:ciscoucs_serviceprofile_clone).new(
   :ensure => 'present',
   :source_profile_dn => 'org-root/ls-test',
   :target_profile_dn => 'org-root/ls-testclone', 
   :source_serviceprofile_name => 'test',
   :source_organization => 'org-root',
   :target_serviceprofile_name => 'testclone',
   :target_organization    => 'org-root',
    )
  end

  public

  def  get_source_profile_dn
    @ciscoucs_serviceprofile_clone[:source_profile_dn]
  end

  def  get_target_profile_dn
    @ciscoucs_serviceprofile_clone[:target_profile_dn]
  end

    def  get_source_serviceprofile_name
    @ciscoucs_serviceprofile_clone[:source_serviceprofile_name]
  end

  def  get_source_organization
    @ciscoucs_serviceprofile_clone[:source_organization]
  end

    def  get_target_serviceprofile_name
    @ciscoucs_serviceprofile_clone[:target_serviceprofile_name]
  end

  def  get_target_organization
    @ciscoucs_serviceprofile_clone[:target_organization]
  end

end