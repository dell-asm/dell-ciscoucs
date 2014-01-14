require 'spec_helper'
require 'yaml'

describe Puppet::Type.type(:ciscoucs_serviceprofile).provider(:default) do

   ciscoucs_serviceprofile_yml =  YAML.load_file(my_fixture('ciscoucs_serviceprofile.yml'))
   poweron = ciscoucs_serviceprofile_yml['poweron']  
   
   transport_yml =  YAML.load_file(my_fixture('transport.yml'))
   transport_node = transport_yml['transport']
       
  let(:power_on) do
     @catalog = Puppet::Resource::Catalog.new
     
       transport = Puppet::Type.type(:transport_ciscoucs).new({
       :name => transport_node['name'],
       :username => transport_node['username'],
       :password => transport_node['password'],
       :server   => transport_node['server'],     
      })

      
     @catalog.add_resource(transport)
 
   Puppet::Type.type(:ciscoucs_serviceprofile).new(
     :name               => poweron['name'],
     :serviceprofile_name   => poweron['serviceprofile_name'],
     :transport          => transport, 
     :catalog            => @catalog,
     :organization       => poweron['organization'],
     :power_state       => poweron['power_state'],
     :profile_dn         => poweron['profile_dn']     
     )
     
   end  
   
 
  poweroff = ciscoucs_serviceprofile_yml['poweroff']
   
   let :power_off do
     @catalog = Puppet::Resource::Catalog.new
           transport = Puppet::Type.type(:transport_ciscoucs).new({
           :name => transport_node['name'],
           :username => transport_node['username'],
           :password => transport_node['password'],
           :server   => transport_node['server'],
         
          })
         @catalog.add_resource(transport)
     
       Puppet::Type.type(:ciscoucs_serviceprofile).new(
         :name               => poweroff['name'],
         :serviceprofile_name   => poweroff['serviceprofile_name'],
         :transport          => transport, 
         :catalog            => @catalog,
         :organization       => poweroff['organization'],
         :power_state       => poweroff['power_state'],
         :profile_dn         => poweroff['profile_dn']
         
         )
       end  
 
   describe "when changing the power state of ciscoucs to up" do     
     it "should be able to change the state to up" do
       power_on.provider.create
     end
   end
 
   describe "when changing the power state of ciscoucs to down" do
     it "should be able to change power state to down" do
       power_off.provider.create
     end
   end
 end