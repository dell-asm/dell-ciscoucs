require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_serviceprofile_clone).provider(:default) do

   ciscoucs_serviceprofile_clone_yml =  YAML.load_file(my_fixture('ciscoucs_serviceprofile_clone.yml'))
   
   transport_yml =  YAML.load_file(my_fixture('transport.yml'))
   transport_node = transport_yml['transport']
        
  serviceprofileclone = ciscoucs_serviceprofile_clone_yml['serviceprofileclone'] 
     
   let :clone_service_profile do
       @catalog = Puppet::Resource::Catalog.new
             transport = Puppet::Type.type(:transport_ciscoucs).new({
             :name => transport_node['name'],
             :username => transport_node['username'],
             :password => transport_node['password'],
             :server   => transport_node['server'],
           
            })
           @catalog.add_resource(transport)
       
         Puppet::Type.type(:ciscoucs_serviceprofile_clone).new(
           :source_profile_dn               => serviceprofileclone['source_profile_dn'],
           :target_profile_dn   => serviceprofileclone['target_profile_dn'],
           :transport          => transport, 
           :catalog            => @catalog,
           :source_serviceprofile_name       => serviceprofileclone['source_serviceprofile_name'],
           :target_serviceprofile_name         => serviceprofileclone['target_serviceprofile_name'],
           :ensure         => serviceprofileclone['ensure'],
           :target_organization         => serviceprofileclone['target_organization'],
		   :source_organization         => serviceprofileclone['source_organization'],

           )
         end  
    
  describe "when cloning the service profile" do
      it "it should able to clone service profile" do
        clone_service_profile.provider.create 
      end
    end
   
 end