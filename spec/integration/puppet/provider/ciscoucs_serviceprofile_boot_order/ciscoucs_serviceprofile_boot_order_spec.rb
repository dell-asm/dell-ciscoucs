require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_serviceprofile_boot_order).provider(:default) do 

   ciscoucs_serviceprofile_boot_order_yml =  YAML.load_file(my_fixture('ciscoucs_serviceprofile_boot_order.yml'))
   modify = ciscoucs_serviceprofile_boot_order_yml['modifyboot_order']  
   
   transport_yml =  YAML.load_file(my_fixture('transport.yml'))
   transport_node = transport_yml['transport']
     
     
     
  let(:boot_order_modify) do
      @catalog = Puppet::Resource::Catalog.new
      
        transport = Puppet::Type.type(:transport_ciscoucs).new({
        :name => transport_node['name'],
        :username => transport_node['username'],
        :password => transport_node['password'],
        :server   => transport_node['server'],     
       })
 
       
      @catalog.add_resource(transport)
  
  
     
    Puppet::Type.type(:ciscoucs_serviceprofile_boot_order).new(
      :name                        => modify['name'],
      :ensure                      => modify['ensure'],
      :transport                   => transport, 
      :catalog                     => @catalog,
      :bootpolicy_dn               => modify['bootpolicy_dn'],
      :bootpolicy_name             => modify['bootpolicy_name'],
      :organization                => modify['organization'],
      :lan_order                   => modify['lan_order']
      )
      
    end  
    
  describe "when changing the boot order of lan in ciscoucs" do     
      it "should be able to change the order of lan" do
        boot_order_modify.provider.create
      end
    end


end

