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
       
    formatter = PuppetX::Util::Ciscoucs::xmlformatter.new("updatelanBootOrderPolicy")
        parameters = PuppetX::Util::Ciscoucs::NestedHash.new
        parameters['/configResolveClass'][:cookie] = cookie
        parameters['/configResolveClass/inFilter/eq'][:value] = resource[:policyname] 
    
        requestxml = formatter.command_xml(parameters);
    
        if requestxml.to_s.strip.length == 0
          raise Puppet::Error, "Cannot create request xml for boot order policy"
          end
        responsexml = post requestxml
        if responsexml.to_s.strip.length == 0
          raise Puppet::Error, "No response obtained from boot order policy"
        end
       
    ucsbootorderDoc = REXML::Document.new(responsexml)
    
    @rnarray = Array.new
    
    if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootLan"]
       lanorder = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootLan"].attributes["order"]
       @rnarray[lanorder.to_i-1] = "lan"
    end 
      
    if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootStorage"]
       sanorder = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootStorage"].attributes["order"]
       @rnarray[sanorder.to_i-1] = "storage"
    end
          
    if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootIScsi"]
       iscsiorder = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootIScsi"].attributes["order"]
       @rnarray[iscsiorder.to_i-1] = "iscsi"
    end

    if ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia"] && 
       ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia"].attributes["type"].eql?('virtual-media')
       ucsbootorderDoc.elements.each("/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia") {
                |media|
                 rn = media.attributes["rn"]
                
                 if rn=="read-write-vm"
                     worder = media.attributes["order"]
                     @rnarray[worder.to_i-1] = "read-write-vm"
                 end
                 if rn=="read-only-vm"
                     rorder = media.attributes["order"]
                     @rnarray[rorder.to_i-1] = "read-only-vm"
                 end
                   
        }           
    end 
             
    lancurorder=@rnarray.find_index { |e| e.match( /lan/ ) }.to_i
    @rnarray.insert(resource[:lanorder].to_i-1, @rnarray.delete_at(lancurorder.to_i))

xml_content = xml_template "updateBootPolicyOrder"
temp_doc = REXML::Document.new(xml_content)
policyElem = temp_doc.elements["/configConfMos/inConfigs/pair/lsbootPolicy"]
updateparameters = PuppetX::Util::Ciscoucs::NestedHash.new
updateparameters['/configConfMos'][:cookie] = cookie
updateparameters['/configConfMos/inConfigs/pair'][:key] = resource[:policyname]
updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy'][:dn] = resource[:policyname]

for elm in @rnarray do
 

  if elm == "iscsi"
    policyElem.add_element 'lsbootIScsi', {'rn' => '', 'order' => ''}
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:rn] = "iscsi"
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:order] = @rnarray.find_index { |e| e.match( /iscsi/ ) }.to_i + 1
  end
  if elm == "lan"
    policyElem.add_element 'lsbootLan', {'rn' => '', 'order' => ''}
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootLan'][:rn] = "lan"
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootLan'][:order] = @rnarray.find_index { |e| e.match( /lan/ ) }.to_i + 1
  end
  if elm == "storage"
    policyElem.add_element 'lsbootStorage', {'rn' => '', 'order' => ''}
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootStorage'][:rn] = "storage"
    updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootStorage'][:order] = @rnarray.find_index { |e| e.match( /storage/ ) }.to_i + 1
  end
  #if elm == "read-write-vm"
   # policyElem.add_element 'lsbootVirtualMedia', {'rn' => '', 'order' => ''}
   # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:rn] = "iscsi"
   # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:order] = @rnarray.find_index { |e| e.match( /iscsi/ ) }.to_i
  #end
  #if elm == "read-only-vm"
   # policyElem.add_element 'lsbootVirtualMedia', {'rn' => '', 'order' => ''}
  # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:rn] = "iscsi"
  # updateparameters['/configConfMos/inConfigs/pair/lsbootPolicy/lsbootIScsi'][:order] = @rnarray.find_index { |e| e.match( /iscsi/ ) }.to_i
  #end
end

puts temp_doc
  temp_file_path = File.join xml_template_path, "temp_update_boot_policy"
  temp_file_path+= ".xml"
  File.open(temp_file_path,"w") do |data|
     data<<temp_doc
   end
   
  temp_formatter = PuppetX::Util::Ciscoucs::xmlformatter.new("temp_update_boot_policy")
  temp_requestxml = temp_formatter.command_xml(updateparameters);
  
  temp_responsexml = post temp_requestxml
  
   # todo: delete temporary xml file 
  # todo: order exceed the limit
=begin
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
      unless element.attributes["access"].eql?('read-only')
        puts("Inside the loop i =>>>>>>>>>>>>>>>>>>>>> #$i" )
        element = ucsbootorderDoc.elements["/configResolveClass/outConfigs/lsbootPolicy/lsbootVirtualMedia"]
      end
    puts 'read-only'
    element.attributes['order'] = @rnarray.find_index { |e| e.match( /read-only-vm/ ) }.to_i
    
  end
 end

=end

end 
     
def xml_template_path
          module_lib = Pathname.new(__FILE__).parent.parent.parent.parent
          File.join module_lib.to_s, '/puppet_x/util/ciscoucs/xml'
end

   def xml_template (filename)
         content = ""
         xml_path = File.join xml_template_path, filename
         xml_path+= ".xml"
         if File.exists?(xml_path)
            # read file in block will close the file handle internally when block terminates
            content = File.open(xml_path, 'r') { |file| file.read }
         else
            raise Puppet::Error, "Cannot read request xml template from location: " + xml_path
         end
         return content
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
