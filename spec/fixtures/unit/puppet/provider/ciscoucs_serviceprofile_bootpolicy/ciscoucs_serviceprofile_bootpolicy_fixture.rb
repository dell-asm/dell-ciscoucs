class Ciscoucs_serviceprofile_bootpolicy_fixture
  attr_accessor :ciscoucs_serviceprofile_bootpolicy, :provider
  def initialize
    @ciscoucs_serviceprofile_bootpolicy = get_ciscoucs_serviceprofile_bootpolicy
    @provider = ciscoucs_serviceprofile_bootpolicy.provider
  end

  def  get_ciscoucs_serviceprofile_bootpolicy
    Puppet::Type.type(:ciscoucs_serviceprofile_bootpolicy).new(
   :ensure => 'modify',
   :serviceprofile_dn => 'org-root/ls-test',
   :bootpolicy_dn => 'org-root/boot-policy-testpolicy', 
   :serviceprofile_name => 'test',
   :serviceprofile_organization => 'org-root',
   :bootpolicy_name => 'test_policy',
   :bootpolicy_organization    => 'org-root',
    )
  end

  public

  def  get_serviceprofile_dn
    @ciscoucs_serviceprofile_bootpolicy[:serviceprofile_dn]
  end

  def  get_bootpolicy_dn
    @ciscoucs_serviceprofile_bootpolicy[:bootpolicy_dn]
  end

    def  get_serviceprofile_name
    @ciscoucs_serviceprofile_bootpolicy[:serviceprofile_name]
  end

  def  get_serviceprofile_organization
    @ciscoucs_serviceprofile_bootpolicy[:serviceprofile_organization]
  end

    def  get_bootpolicy_name
    @ciscoucs_serviceprofile_bootpolicy[:bootpolicy_name]
  end

  def  get_bootpolicy_organization
    @ciscoucs_serviceprofile_bootpolicy[:bootpolicy_organization]
  end

end