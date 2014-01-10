class Ciscoucs_serviceprofile_poweron_fixture

  attr_accessor :ciscoucs_serviceprofile, :provider
  def initialize
    @ciscoucs_serviceprofile = get_serviceprofile_poweron
    @provider = ciscoucs_serviceprofile.provider
  end


  def  get_serviceprofile_poweron
    Puppet::Type.type(:ciscoucs_serviceprofile).new(
    :organization => 'root/org',
    :serviceprofile_name => 'testServiceProfile',
    :power_state => 'up'
    )
  end

  public

  def get_serviceprofile_name
    ciscoucs_serviceprofile[:serviceprofile_name]
  end

  def set_power_state_up
    ciscoucs_serviceprofile[:power_state] = 'up'
  end

  def set_power_state_down
   ciscoucs_serviceprofile[:power_state] = 'down'
 end
end

