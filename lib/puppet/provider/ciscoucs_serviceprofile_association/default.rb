require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_association).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  @doc = "Manage association of service profile on Cisco UCS device."

  include PuppetX::Puppetlabs::Transportciscoucs
  @doc = "Associate or dissociate server profile on Cisco UCS device."

  @error_codes_array = Array.new(9);

  @state = "";
  @config_state = "";
  @error_code = "";
  
  @result = "";
  
  def create
    # check if the profile exists
    if ! check_element_exists profile_dn_name
      raise Puppet::Error, "The " + profile_dn_name + " service profile does not exist."
    end
    
    @result = "";
   
    # check if blade is already associated with service profile
    check_server_already_associated server_dn_name
    
    
    if @result.to_s != ""
          raise Puppet::Error, "Service Profile already associated with '"+server_dn_name+"' is '"+@result.to_s ;
          return;
    end

    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("associateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn_name
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn_name
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:pnDn] = server_dn_name
    parameters['/configConfMos/inConfigs/pair/lsServer'][:descr] = "Service Profile Association";
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:rn] = "pn";
    requestxml = formatter.command_xml(parameters);

    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create a request XML for the Associate Service Profile operation."
    end
    
    responsexml = post requestxml

    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the Associate Service Profile operation."
    end
  

    check_operation_state_till_associate_completion(profile_dn_name);

    disconnect;

  end

  def destroy
    # check if the profile exists
    if ! check_element_exists profile_dn_name
      raise Puppet::Error, "The " + profile_dn_name + " service profile does not exist."
    end

    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("disAssociateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn_name
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn_name
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:status] = "deleted";
    parameters['/configConfMos/inConfigs/pair/lsServer'][:descr] = "Service Profile Disassociation";
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:rn] = "pn";
    requestxml = formatter.command_xml(parameters);

    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create a request XML for the Dissociate Service Profile operation."
    end
    
    responsexml = post requestxml

    if responsexml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to get a response from the Dissociate Service Profile operation."
    end
   

    check_operation_state_till_dissociate_completion(profile_dn_name)

    disconnect

  end

  def server_dn_name
    server_dn(resource[:profile_dn], resource[:server_chassis_id], resource[:server_slot_id])
  end

  def profile_dn_name
    profile_dn(resource[:serviceprofile_name], resource[:organization], resource[:server_dn])
  end
  
  #get associated service profile
  def check_server_already_associated(server_dn_name)

    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("lsServerSingle")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie;
    parameters['/configResolveClass'][:classId] = "lsServer";
    parameters['/configResolveClass'][:inHierarchical] = "yes";
    parameters['/configResolveClass/inFilter/eq'][:class] = "lsServer";
    parameters['/configResolveClass/inFilter/eq'][:property] = "pnDn";
    parameters['/configResolveClass/inFilter/eq'][:value] = server_dn_name;
    requestxml = formatter.command_xml(parameters);
    
    if requestxml.to_s.strip.length == 0
      raise Puppet::Error, "Unable to create a request XML for the check associated service profile to server."
    end

    responsexml = post requestxml;

    parse_associated_service_profile(responsexml);   

  end

  #check operation status till completion
  def check_operation_state_till_associate_completion(profile_dn_name)

    @error_codes_array = ['connection-placement','vhba-capacity', 'vnic-capacity', 'mac-address-assignment', 'system-uuid-assignment', 'empty-pool', 'named-policy-unresolved', 'wwpn-assignment', 'wwnn-assignment'];

    maxCount = 60;
    failConfigMaxCount = 5;
    counter = 0;
    failConfigCount = 0;
    

    while counter < maxCount  do
      response_xml = call_for_current_state(profile_dn_name);
           
      parseState(response_xml);

      if @config_state == "failed-to-apply"
        if failConfigCount >= failConfigMaxCount
          
          if @error_code != ''
            if parse_error_code(@error_code)
              Puppet.notice(@error_code.to_s);
              next;
            end
          end
          
          Puppet.notice(@error_code.to_s);
          
          return @error_code;

          
          else
            failConfigCount = failConfigCount+1;
          
          sleep(60);
          next;
        end

      end

      if @state == "associated"
        Puppet.notice('successfully associated!');
        break;
      end

      sleep(60);
      counter = counter  +  1;
    end

    Puppet.notice("Fails to associate service profile");

  end

  #check operation status till completion
  def check_operation_state_till_dissociate_completion(profile_dn_name)
    maxCount = 10;
    counter = 0;

    while counter < maxCount  do
      response_xml = call_for_current_state(profile_dn_name);
      parseState(response_xml);
      Puppet.notice(response_xml);
      
      if @state == "unassociated"
        Puppet.notice('successfully dissociated!');
        return;
      end
      sleep(60);
      counter = counter+1;
    end

    Puppet.notice("Fails to dissociate service profile");
  end

  #call for current state
  def call_for_current_state(profile_dn_name)
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("getServiceProfileState")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass'][:classId] = "lsServer";
    parameters['/configResolveClass'][:inHierarchical] = "false";
    parameters['/configResolveClass/inFilter/eq'][:class] = "lsServer"
    parameters['/configResolveClass/inFilter/eq'][:property] = "dn";
    parameters['/configResolveClass/inFilter/eq'][:value] = profile_dn_name;
    requestxml = formatter.command_xml(parameters);
    responsexml = post requestxml;
    return responsexml;
  end

  #parse the state of association
  def parseState(response_xml)
    myelement = REXML::Document.new(response_xml);
    root = myelement.root
    myelement.elements.each("/configResolveClass/outConfigs/lsServer") {
      |e|

      @state = e.attributes['assocState'].to_s;
      @config_state = e.attributes['configState'].to_s;
      @error_code = e.attributes['configQualifier'].to_s;

    }

  end
  
  #parse the state of association
  def parse_associated_service_profile(response_xml)
    myelement = REXML::Document.new(response_xml);
    root = myelement.root
    
    
    myelement.elements.each("/configResolveClass/outConfigs/") {
      |e|
    
      if e.elements['lsServer'] != nil;
        @result = e.elements['lsServer'].attributes['dn'].to_s;
      end

    }

  end
  
    

  #parse error and check
  def parse_error_code(error_code)
    result = false;

    output_errors = error_code.split(',');

    output_errors.each {
      |x|
      @error_codes_array.each{
        |y|

        if x.to_s == y.to_s
          result = true;
        end

      }
    }
    return result;
  end

  #check If exist
  def exists?
    ens = resource[:ensure]
    result = true;
    if (ens.to_s =="present")
      result = false;
    end
    return result;
  end
  #question: do we have to delete the profile
end