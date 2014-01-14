class Ciscoucs_serviceprofile_boot_order_fixture
  attr_accessor :ciscoucs_serviceprofile_boot_order, :provider
  def initialize
    @ciscoucs_serviceprofile_boot_order = get_ciscoucs_serviceprofile_boot_order
    @provider = ciscoucs_serviceprofile_boot_order.provider
  end

  def  get_ciscoucs_serviceprofile_boot_order
    Puppet::Type.type(:ciscoucs_serviceprofile_boot_order).new(
   :ensure => 'present',
   :bootpolicy_dn => 'org-root/boot-policy-testbootpolicy', 
   :bootpolicy_name => 'test_policy',
   :organization    => 'org-root',
   :lan_order => '5',
    )
  end

  public

  def  get_lan_order
    @ciscoucs_serviceprofile_boot_order[:lan_order]
  end

  def  get_bootpolicy_dn
    @ciscoucs_serviceprofile_boot_order[:bootpolicy_dn]
  end

    def  get_bootpolicy_name
    @ciscoucs_serviceprofile_boot_order[:bootpolicy_name]
  end

  def  get_organization
    @ciscoucs_serviceprofile_boot_order[:organization]
  end

end