require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

ucs_module = Puppet::Module.find('ciscoucs', Puppet[:environment].to_s)
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/nested_hash'
require File.join ucs_module.path, 'lib/puppet_x/util/ciscoucs/xml_formatter'

Puppet::Type.type(:ciscoucs_updatelan_boot_order).provide(:default, :parent => Puppet::Provider::Ciscoucs) do

  include PuppetX::Puppetlabs::Transport
  @doc = "Create server profile on Cisco UCS device."
  def create
    puts "inside create method"
   
    formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("updatelanBootOrderPolicy")
        parameters = PuppetX::Util::Ciscoucs::NestedHash.new
        parameters['/configResolveClass'][:cookie] = cookie
   #     parameters['/configResolveClass'][:inHierarchical] = 'true'
  #      parameters['/configResolveClass'][:classId] = 'lsbootPolicy'
 #       parameters['/configResolveClass/inFilter/eq'][:class] = 'computeItem'
#        parameters['/configResolveClass/inFilter/eq'][:property] =resource[:dn]
        parameters['/configResolveClass/inFilter/eq'][:value] = resource[:value] 
    
        requestxml = formatter.command_xml(parameters);
    #puts requestxml
        if requestxml.to_s.strip.length == 0
          raise Puppet::Error, "Cannot create request xml for boot order policy"
          end
        responsexml = post requestxml
        if responsexml.to_s.strip.length == 0
          raise Puppet::Error, "No response obtained from boot order policy"
        end
    
       
      puts "response XML ::::::::::::::" +responsexml
   
    ucsbootorderDoc = REXML::Document.new(responsexml)
    
    @rnarray = Array.new
    
      if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootLan"]
      
    lanorder = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootLan"].attributes["order"]
      puts "lannn ::::"+ lanorder
      @rnarray[lanorder.to_i-1] = "lan"
      puts resource[:value] 
      
        end 
      
        if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootStorage"]
        
    sanorder = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootStorage"].attributes["order"]
          puts "sannn ::::::::"+sanorder
          
          @rnarray[sanorder.to_i-1] = "storage"
          
          
          end
          
           if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootIScsi"]
          
    iscsiorder = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootIScsi"].attributes["order"]
          puts "iscsi ::::::::::::::"+iscsiorder
          
             @rnarray[iscsiorder.to_i-1] = "iscsi"
            
          
             end

    if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia"].attributes["type"].eql?('virtual-media')
      ucsbootorderDoc.elements.each("/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia") {
                |media|
                
                 rn = media.attributes["rn"]
                
                   if rn=="read-write-vm"
                     worder = media.attributes["order"]
                     puts "write      media order:::::::::::: " + worder
                     
                     @rnarray[worder.to_i-1] = "read-write-vm"
                     
                   end
                   
        if rn=="read-only-vm"
          rorder = media.attributes["order"]
          puts "read       media order:::::::::::::::::::::::::::: " + rorder
          
          @rnarray[rorder.to_i-1] = "read-only-vm"
          
        end
                   
        }           
           
        
    end 
             
puts "#{@rnarray}"

puts "Lan required order ::::::::"+resource[:lanorder] 

  lancurorder=@rnarray.find_index { |e| e.match( /lan/ ) }.to_i
puts "Lan Current order :::::::::::::::::::::"+lancurorder.to_s

=begin
arr = [ "i","ro","s","l","rw" ] 
arr.insert(1, arr.delete_at(3))
#arr.shuffle! until arr[1] == 'a' && arr[0]=='b'
#p arr #=> ["b", "a", "c"]
puts arr
=end
puts "------------------------------------------------------------------Re-Ordered Array"
@rnarray.insert(resource[:lanorder].to_i-1, @rnarray.delete_at(lancurorder.to_i))
puts "#{@rnarray}"






for elm in @rnarray do
  if elm == "iscsi"
  ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootIScsi"].attributes['order'] = @rnarray.find_index { |e| e.match( /iscsi/ ) }.to_i
  end
  if elm == "lan"
    ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootLan"].attributes['order'] = @rnarray.find_index { |e| e.match( /lan/ ) }.to_i
    end
  if elm == "storage"
    ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootStorage"].attributes['order'] = @rnarray.find_index { |e| e.match( /storage/ ) }.to_i
    end
  if elm == "read-write-vm"
    puts "read-write-vm"
    puts @rnarray.find_index { |e| e.match( /read-write-vm/ ) }.to_i
    element = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia"]
    if element.attributes["access"].eql?('read-write')
      puts 'read-write'
      element.attributes['order'] = @rnarray.find_index { |e| e.match( /read-write-vm/ ) }.to_i
    end
  end
  if elm == "read-only-vm"
    puts "read-only-vm"
    puts  @rnarray.find_index { |e| e.match( /read-only-vm/ ) }.to_i
    element = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia"]
    $i = 0
      while ! element.attributes["access"].eql?('read-only')
        puts("Inside the loop i =>>>>>>>>>>>>>>>>>>>>> #$i" )
        element = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia"]
      end
    puts 'read-only'
    element.attributes['order'] = @rnarray.find_index { |e| e.match( /read-only-vm/ ) }.to_i
    
  end
  

end
  
  
  puts "seding ---------"
  ucsbootorderDoc.context[:attribute_quote] = :quote
  puts ucsbootorderDoc
  responsexml1 = post ucsbootorderDoc
  puts"#########################################################################################################################3"
  puts responsexml1
end 
     
    
      #check If exist
      def exists?
        ens = resource[:ensure]
                  result = false;
                  if (ens.to_s =="absent")       
                    result = true;
                  elsif (ens.to_s =="absent")        
                    result = true;
                  end  
                 
                  return result;
              end
        end