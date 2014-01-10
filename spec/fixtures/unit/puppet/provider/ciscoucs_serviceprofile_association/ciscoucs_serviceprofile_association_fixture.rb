class Ciscoucs_serviceprofile_association_fixture

  attr_accessor :ciscoucs_serviceprofile_association, :provider
  
  def initialize
    @ciscoucs_serviceprofile_association = get_ciscoucs_serviceprofile_association
    @provider = ciscoucs_serviceprofile_association.provider
  end


  def  get_ciscoucs_serviceprofile_association
    Puppet::Type.type(:ciscoucs_serviceprofile_association).new(
            :ensure              => 'present',
            :organization        => 'org-root',
            :serviceprofile_name => 'testing',
            :profile_dn          => '',
            :server_chassis_id   => 'chassis-1',
            :server_slot_id      => 'blade-3',
            :server_dn           => ''    
    )
  end

  public
  
  def get_ensure
    ciscoucs_serviceprofile[:ensure]
  end

  def get_organization
    ciscoucs_serviceprofile[:organization]
  end

  def get_serviceprofile_name
    ciscoucs_serviceprofile[:serviceprofile_name]
  end

  def get_profile_dn
    ciscoucs_serviceprofile[:profile_dn]
  end

  def get_server_chassis_id
    ciscoucs_serviceprofile[:server_chassis_id]
  end

  def get_server_slot_id
    ciscoucs_serviceprofile[:server_slot_id]
  end

  def get_server_dn
    ciscoucs_serviceprofile[:server_dn]
  end
  
end

