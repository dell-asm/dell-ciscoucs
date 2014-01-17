require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_serviceprofile_bootpolicy).provider(:default) do 

   ciscoucs_serviceprofile_bootpolicy_yml =  YAML.load_file(my_fixture('ciscoucs_serviceprofile_bootpolicy.yml'))
   modify = ciscoucs_serviceprofile_bootpolicy_yml['modifybootpolicy']  
   
   transport_yml =  YAML.load_file('transport.yml')
   transport_node = transport_yml['transport']
     
     
     
  let(:bootpolicy_modify) do
      @catalog = Puppet::Resource::Catalog.new
        transport = Puppet::Type.type(:transport_ciscoucs).new({
        :name => transport_node['name'],
        :username => transport_node['username'],
        :password => transport_node['password'],
        :server   => transport_node['server'],     
       })  
      @catalog.add_resource(transport)
    Puppet::Type.type(:ciscoucs_serviceprofile_bootpolicy).new(
      :name                        => modify['name'],
      :ensure                      => modify['ensure'],
      :transport                   => transport, 
      :catalog                     => @catalog,
      :bootpolicy_dn               => modify['bootpolicy_dn'],
      :bootpolicy_name             => modify['bootpolicy_name'],
      :bootpolicy_organization     => modify['bootpolicy_organization'],
      :serviceprofile_dn           => modify['serviceprofile_dn'],
      :serviceprofile_name         => modify['serviceprofile_name'],
      :serviceprofile_organization => modify['serviceprofile_organization']          
      )
      
    end  
    
  describe "when changing the boot policy of service profile in ciscoucs" do     
      it "should be able to change the boot policy of service profile" do
        bootpolicy_modify.provider.create
      end
    end


end

