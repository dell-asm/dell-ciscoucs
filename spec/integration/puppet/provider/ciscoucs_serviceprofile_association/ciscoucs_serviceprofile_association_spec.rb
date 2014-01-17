require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_serviceprofile_association).provider(:default) do
   ciscoucs_serviceprofile_associate_yml =  YAML.load_file(my_fixture('ciscoucs_serviceprofile_association.yml'))
   serviceprofileassociate = ciscoucs_serviceprofile_associate_yml['associate']

   transport_yml =  YAML.load_file('transport.yml')
   transport_node = transport_yml['transport']

   let(:serviceprofile_associate) do
   @catalog = Puppet::Resource::Catalog.new

	transport = Puppet::Type.type(:transport_ciscoucs).new({
    :name     => transport_node['name'],
    :username => transport_node['username'],
    :password => transport_node['password'],
    :server   => transport_node['server'],
    })

      
    @catalog.add_resource(transport)
 
   Puppet::Type.type(:ciscoucs_serviceprofile_association).new(
     :name                => serviceprofileassociate['name'],
     :serviceprofile_name => serviceprofileassociate['serviceprofile_name'],
     :transport           => transport,
     :catalog             => @catalog,
     :organization        => serviceprofileassociate['organization'],
     :ensure              => serviceprofileassociate['ensure'],
     :profile_dn          => serviceprofileassociate['profile_dn'],
	  :server_dn          => serviceprofileassociate['server_dn'],
     :server_slot_id      => serviceprofileassociate['server_slot_id'],
	 :server_chassis_id   => serviceprofileassociate['server_chassis_id'],
     )
    end

    serviceprofiledisassociate = ciscoucs_serviceprofile_associate_yml['disassociate']

   let(:serviceprofile_disassociate) do
   @catalog = Puppet::Resource::Catalog.new

    transport = Puppet::Type.type(:transport_ciscoucs).new({
    :name     => transport_node['name'],
    :username => transport_node['username'],
    :password => transport_node['password'],
    :server   => transport_node['server'],
    })

	@catalog.add_resource(transport)

	Puppet::Type.type(:ciscoucs_serviceprofile_association).new(
     :name                => serviceprofiledisassociate['name'],
     :serviceprofile_name => serviceprofiledisassociate['serviceprofile_name'],
     :transport           => transport,
     :catalog             => @catalog,
     :organization        => serviceprofiledisassociate['organization'],
     :ensure              => serviceprofiledisassociate['ensure'],
     :profile_dn          => serviceprofiledisassociate['profile_dn'],
	 :server_dn           => serviceprofiledisassociate['server_dn'],
     :server_slot_id      => serviceprofiledisassociate['server_slot_id'],
	 :server_chassis_id   => serviceprofiledisassociate['server_chassis_id'],
	 )
     end



   describe "when associate the service profile to a server" do     
     it "should be able to associate the service profile to a server" do
       serviceprofile_associate.provider.create
     end
   end

   describe "when disassociate the service profile to a server" do     
     it "should be able to disassociate the service profile to a server" do
       serviceprofile_disassociate.provider.create
     end
   end

 end