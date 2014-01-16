class Ciscoucs_serviceprofile_clone_fixture
  attr_accessor :ciscoucs_vlan_vnic_template, :provider
  def initialize
    @ciscoucs_vlan_vnic_template = get_ciscoucs_vlan_vnic_template
    @provider = ciscoucs_vlan_vnic_template.provider
  end

  def  get_ciscoucs_vlan_vnic_template
    Puppet::Type.type(:ciscoucs_vlan_vnic_template).new(
	   :ensure => 'present',
	   :vnictemplateorg => 'org-root',
	   :vlanname => 'VLAN20', 
	   :defaultnet => 'yes',
    )
  end

  public

  def  get_vnictemplateorg
    @ciscoucs_vlan_vnic_template[:vnictemplateorg]
  end

  def  get_vlanname
    @ciscoucs_vlan_vnic_template[:vlanname]
  end

    def  get_defaultnet
    @ciscoucs_vlan_vnic_template[:defaultnet]
  end

end