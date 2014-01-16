class Ciscoucs_serviceprofile_clone_fixture
  attr_accessor :ciscoucs_vlan_serviceprofile, :provider
  def initialize
    @ciscoucs_vlan_serviceprofile = get_ciscoucs_vlan_serviceprofile
    @provider = ciscoucs_vlan_serviceprofile.provider
  end

  def  get_ciscoucs_vlan_serviceprofile
    Puppet::Type.type(:ciscoucs_vlan_serviceprofile).new(
	   :ensure => 'present',
	   :serviceprofileorg => 'org-root',
	   :vlan_name => 'VLAN20', 
	   :defaultnet => 'yes',
	   :vnic => 'eth10',
    )
  end

  public

  def  get_serviceprofileorg
    @ciscoucs_vlan_serviceprofile[:serviceprofileorg]
  end

  def  get_vlan_name
    @ciscoucs_vlan_serviceprofile[:vlan_name]
  end

    def  get_defaultnet
    @ciscoucs_vlan_serviceprofile[:defaultnet]
  end

  def  get_vnic
    @ciscoucs_vlan_serviceprofile[:vnic]
  end

end