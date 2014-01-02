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

  lancurorder=@rnarray.find_index { |e| e.match( /lan/ ) }.to_i+1
puts "Lan Current order :::::::::::::::::::::"+lancurorder.to_s

arr = [ "a","b","c" ] 
arr.shuffle! until arr[1] == 'a' && arr[0]=='b'
#p arr #=> ["b", "a", "c"]
puts arr

  
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