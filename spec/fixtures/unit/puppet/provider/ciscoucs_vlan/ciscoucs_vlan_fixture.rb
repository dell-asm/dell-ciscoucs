class Ciscoucs_serviceprofile_clone_fixture
  attr_accessor :ciscoucs_vlan, :provider
  def initialize
    @ciscoucs_vlan = get_ciscoucs_vlan
    @provider = ciscoucs_vlan.provider
  end

  def  get_ciscoucs_vlan
    Puppet::Type.type(:ciscoucs_vlan).new(
	   :ensure => 'present',
	   :vlanid => '1092',
	   :mcast_policy_name => '', 
	   :sharing => 'primary',
	   :fabric_id => 'B',
	   :status => 'created',
    )
  end

  public

  def  get_vlanid
    @ciscoucs_vlan[:vlanid]
  end

  def  get_mcast_policy_name
    @ciscoucs_vlan[:mcast_policy_name]
  end

    def  get_sharing
    @ciscoucs_vlan[:sharing]
  end

  def  get_fabric_id
    @ciscoucs_vlan[:fabric_id]
  end

    def  get_status
    @ciscoucs_vlan[:status]
  end

end