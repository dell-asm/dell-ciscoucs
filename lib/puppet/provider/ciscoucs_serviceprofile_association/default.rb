require 'pathname'

provider_path = Pathname.new(__FILE__).parent.parent
Puppet.debug provider_path
require File.join(provider_path, 'ciscoucs')

Puppet::Type.type(:ciscoucs_serviceprofile_association).provide(:default, :parent => Puppet::Provider::Ciscoucs) do
  @doc = "Manage association of service profile on Cisco UCS device."

  include PuppetX::Puppetlabs::Transport
  @doc = "Associate or dissociate server profile on Cisco UCS device."

  @error_codes_array = Array.new(9);

  @state = "";
  @config_state = "";
  @error_code = "";
  def create
    # check if the profile exists
    if ! check_profile_exists profile_dn
      raise Puppet::Error, "The " + profile_dn + " service profile does not exist."
    end

    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("associateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer/lsBinding'][:pnDn] = server_dn
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
  

    check_operation_state_till_associate_completion(profile_dn);

    disconnect;

  end

  def destroy
    # check if the profile exists
    if ! check_profile_exists profile_dn
      raise Puppet::Error, "The " + profile_dn + " service profile does not exist."
    end

    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("disAssociateServiceProfile")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configConfMos'][:cookie] = cookie
    parameters['/configConfMos/inConfigs/pair'][:key] = profile_dn
    parameters['/configConfMos/inConfigs/pair/lsServer'][:dn] = profile_dn
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
   

    check_operation_state_till_dissociate_completion(profile_dn)

    disconnect

  end

  def server_dn
    source_dn = ""
    if (resource[:server_chassis_id] && resource[:server_chassis_id].strip.length > 0) &&
    (resource[:server_slot_id]  && resource[:server_slot_id].strip.length > 0)
      source_dn = 'sys/'+resource[:server_chassis_id]+'/'+resource[:server_slot_id];
    elsif (resource[:profile_dn] && resource[:profile_dn].strip.length > 0)
      source_dn = resource[:profile_dn]
    end
    return source_dn
  end

  def profile_dn
    source_dn = ""
    if (resource[:organization_name] && resource[:organization_name].strip.length > 0) &&
    (resource[:service_profile_name]  && resource[:service_profile_name].strip.length > 0)
      # check if the profile name contains 'ls-'
      profile_name = resource[:service_profile_name]
      if ! profile_name.start_with?('ls-')
        profile_name = "ls-" + profile_name
      end
      source_dn = resource[:organization_name] +"/"+ profile_name
    elsif (resource[:server_dn] && resource[:server_dn].strip.length > 0)
      source_dn = resource[:server_dn]
    end
    return source_dn
  end

  #check operation status till completion
  def check_operation_state_till_associate_completion(profile_dn)

    @error_codes_array = ['connection-placement','vhba-capacity', 'vnic-capacity', 'mac-address-assignment', 'system-uuid-assignment', 'empty-pool', 'named-policy-unresolved', 'wwpn-assignment', 'wwnn-assignment'];

    maxCount = 60;
    failConfigMaxCount = 5;
    counter = 0;
    failConfigCount = 0;
    

    while counter < maxCount  do
      response_xml = call_for_current_state(profile_dn);
      Puppet.notice(response_xml);
      
      parseState(response_xml);

      if @config_state == "failed-to-apply"
        if failConfigCount >= failConfigMaxCount
          
          if @error_code != ''
            if parse_error_code(@error_code)
              Puppet.notice("here I come");
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
  def check_operation_state_till_dissociate_completion(profile_dn)
    maxCount = 10;
    counter = 0;

    while counter < maxCount  do
      response_xml = call_for_current_state(profile_dn);
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
  def call_for_current_state(profile_dn)
    formatter = PuppetX::Util::Ciscoucs::Xmlformatter.new("getServiceProfileState")
    parameters = PuppetX::Util::Ciscoucs::NestedHash.new
    parameters['/configResolveClass'][:cookie] = cookie
    parameters['/configResolveClass'][:classId] = "lsServer";
    parameters['/configResolveClass'][:inHierarchical] = "false";
    parameters['/configResolveClass/inFilter/eq'][:class] = "lsServer"
    parameters['/configResolveClass/inFilter/eq'][:property] = "dn";
    parameters['/configResolveClass/inFilter/eq'][:value] = profile_dn;
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