require 'puppet/util/network_device/ciscoucs'
require 'json'
require 'rexml/document'
require 'rest_client'

module Puppet::Util::NetworkDevice::Ciscoucs
  class Facts
    attr_reader :transport
    def initialize(transport)
      @transport = transport
    end

    def retrieve
      Puppet.debug "Retrieving facts from CiscoUCS device"
      @facts = {}
      @facts['General Settings'] = getgeneralsettinginfo

      formatter = PuppetX::Util::Ciscoucs::Xml_formatter.new("discover")
      parameters = PuppetX::Util::Ciscoucs::NestedHash.new
      parameters['/configResolveClass'][:classId] = 'computeBlade'
      parameters['/configResolveClass'][:cookie] = @transport.cookie

      requestxml = formatter.command_xml(parameters)

      if requestxml.to_s.strip.length == 0
        raise Puppet::Error, "Cannot create request xml for discover operation"
      end
      Puppet.debug "Sending discovery request xml: \n" + requestxml

      begin
        responsexml = RestClient.post @transport.url, requestxml, :content_type => 'text/xml'
      rescue RestClient::Exception => error
        raise Puppet::Error, "\n#{error.exception}:\n#{error.response}"
      end

      @transport.close
      if responsexml.to_s.strip.length == 0
        raise Puppet::Error, "No response obtained from discovery operation"
      end
      Puppet.debug "Response from discovery: \n" + responsexml

      begin
        ucsBladesDoc = REXML::Document.new(responsexml)
        count =1
        ucsBladesDoc.elements.each("configResolveClass/outConfigs/*") {
          |blade|
          bladeName = blade.attributes["dn"]
          bladeSerialNum = blade.attributes["serial"]
          bladeSlotId = blade.attributes["slotId"]
          bladeChassisId = blade.attributes["chassisId"]

          collectionMap = {}
          #collectionMap['BladeDN'] = bladeName
          collectionMap['serialNumber'] = bladeSerialNum
          collectionMap['slot'] = bladeSlotId
          collectionMap['chassisId'] = bladeChassisId
          blade_name = "Blade_"+count.to_s

          @facts['ServerData'] = blade_name
          @facts[blade_name] = collectionMap
          count+=1

        }
      rescue Exception => msg
        raise Puppet::Error, "Following error occurred while parsing discovery response" +  msg.to_s
      end
      # JSON.pretty_generate(@collectionMap)

      puts @facts.to_s
      return  @facts
    end

    def getgeneralsettinginfo

      generalMap = {}
      generalMap['UCS IP'] = @transport.host
      generalMap

    end
  end
end
