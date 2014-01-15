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
       
  createprofilefromtemplate = ciscoucs_serviceprofile_yml['createfromtemplate'] 
    
  let :create_template do
      @catalog = Puppet::Resource::Catalog.new
            transport = Puppet::Type.type(:transport_ciscoucs).new({
            :name => transport_node['name'],
            :username => transport_node['username'],
            :password => transport_node['password'],
            :server   => transport_node['server'],
          
           })
          @catalog.add_resource(transport)
      
        Puppet::Type.type(:ciscoucs_serviceprofile).new(
          :name               => createprofilefromtemplate['name'],
          :serviceprofile_name   => createprofilefromtemplate['serviceprofile_name'],
          :transport          => transport, 
          :catalog            => @catalog,
          :organization       => createprofilefromtemplate['organization'],
          :profile_dn         => createprofilefromtemplate['profile_dn'],
          :ensure         => createprofilefromtemplate['ensure'],
          :source_template         => createprofilefromtemplate['source_template'],
          :number_of_profiles      => createprofilefromtemplate['number_of_profiles']
          
          )
        end  
        
        
        
  createprofilefromserver = ciscoucs_serviceprofile_yml['createfromserver'] 
     
   let :create_server do
       @catalog = Puppet::Resource::Catalog.new
             transport = Puppet::Type.type(:transport_ciscoucs).new({
             :name => transport_node['name'],
             :username => transport_node['username'],
             :password => transport_node['password'],
             :server   => transport_node['server'],
           
            })
           @catalog.add_resource(transport)
       
         Puppet::Type.type(:ciscoucs_serviceprofile).new(
           :name               => createprofilefromserver['name'],
           :serviceprofile_name   => createprofilefromserver['serviceprofile_name'],
           :transport          => transport, 
           :catalog            => @catalog,
           :organization       => createprofilefromserver['organization'],
           :profile_dn         => createprofilefromserver['profile_dn'],
           :ensure         => createprofilefromserver['ensure'],
           :server_chassis_id         => createprofilefromserver['server_chassis_id']

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
   
  describe "when creating server profile from template" do
      it "it should able to create profile from template" do
        create_template.provider.create 
      end
    end
    
  describe "when creating server profile from server" do
      it "it should able to create profile from server" do
        create_server.provider.create 
      end
    end
   
 end