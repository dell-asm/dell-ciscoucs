require 'puppet/util/network_device/equallogic'
require 'puppet/util/network_device/transport_equallogic'
require 'json'

module Puppet::Util::NetworkDevice::Ciscoucs
  class Facts
    attr_reader :transport

    $provider_path = Pathname.new(__FILE__).parent
    $pythonFilePath = "#{$provider_path}/pythonEquallogic.py"
    $volumeFilePath = "#{$provider_path}/volume"
    $poolFilePath = "#{$provider_path}/pool"
    $memberFilePath = "#{$provider_path}/member"

    def initialize(transport)
      @transport = transport
    end

    def retrieve
      @facts = {}
      @facts['General Settings'] = getgeneralsettinginfo
      @facts['Storage Pools'] = getstoragepoolinfo
      @facts['Group Members'] = getmembercountinfo
      volumeList = getvolumelist
      getvolumeproperties(volumeList)
      @facts['Collections'] = getcollectioninfo
      @facts
    end

    def getvolumeproperties(volumeList)
      @volumePropertiesMap = {}
      @volumeCountMap = {}
      @volumeMap = {}
      @snapshotPropertiesMap = {}
      volumeCounter = 0
      onlineVolumeCounter = 0
      iSCSIConnCounter = 0
      snapshotCounter = 0
      onlinesnapshotCounter = 0
      volumeList.each do |volume|
        response = `python "#{$pythonFilePath}" #{@transport.host} #{@transport.user} #{@transport.password} poolvolumeinfo "#{volume}"`
        if (response.match("% Error"))
          raise Puppet::Error, "Failed to fetch the equallogic volume properties: #{response}"
        end
        response.split("\n").each do |line|
          res = line.split(":")
          name = res[0].to_s.strip
          value = res[1].to_s.strip
          if name == "Pool"
            @volumePropertiesMap['Storage Pool'] = value
          elsif name == "Size"
            @volumePropertiesMap['Reported Size'] = value
          elsif name == "VolReserve"
            @volumePropertiesMap['Volume Reserve'] = value
          elsif name == "Snap-Reserve"
            @volumePropertiesMap['Snapshot Reserve'] = value
          elsif name == "Space Borrowed"
            @volumePropertiesMap['Borrowed Space'] = value
          elsif name == "Status"
            @volumePropertiesMap['Volume Status'] = value
            if ("#{value}" == "online")
              onlineVolumeCounter = onlineVolumeCounter + 1
            end
          elsif name == "ReplicationPartner"
            @volumePropertiesMap['Replication Partner'] = value
          elsif name == "SyncReplStatus"
            @volumePropertiesMap['SyncRep Status'] = value
          elsif name == "Snapshots"
            @volumePropertiesMap['Number of Snapshot'] = value
            snapshotCounter = snapshotCounter + value.to_i
          elsif name == "Connections"
            @volumePropertiesMap['ISCSI Connections'] = value
            iSCSIConnCounter = iSCSIConnCounter + value.to_i
          end
        end
        @volumeMap["#{volume}"] = JSON.pretty_generate(@volumePropertiesMap)
        volumeCounter = volumeCounter + 1
        onlinesnapshotCounter = getsnapshotcount(onlinesnapshotCounter,volume)
      end
      @facts['VolumesProperties'] = JSON.pretty_generate(@volumeMap)
      @volumeCountMap['Total Volumes'] = "#{volumeCounter}"
      @volumeCountMap['Online'] = "#{onlineVolumeCounter}"
      @volumeCountMap['ISCSI Connections'] = "#{iSCSIConnCounter}"
      @facts['VolumesInfo'] = JSON.pretty_generate(@volumeCountMap)
      @facts['Volumes'] = "#{volumeCounter}"
      @facts['Snapshots'] = "#{snapshotCounter}"
      @snapshotPropertiesMap['Online'] = "#{onlinesnapshotCounter}"
      @facts['SnapshotsInfo'] = JSON.pretty_generate(@snapshotPropertiesMap)
    end

    def getsnapshotcount(onlinesnapshotCounter,volume)
      counter = 0
      response = `python "#{$pythonFilePath}" #{@transport.host} #{@transport.user} #{@transport.password} snapshotshow "#{volume}"`
      if (response.match("% Error"))
        raise Puppet::Error, "Failed to fetch the equallogic snapshot properties: #{response}"
      end
      response.split("\n").each do |line|
        if (counter < 2)
          counter = counter + 1
          next
        end
        if (line.to_s.strip.length > 0 )
          res = line.to_s.strip.split(" ")
          if (res[2].to_s.strip.length > 0 && "#{res[2]}" == "online" )
            onlinesnapshotCounter = onlinesnapshotCounter + 1
          end
        end
      end
      onlinesnapshotCounter
    end

    def getcollectioninfo
      @collectionMap = {}
      counter = 0
      volumeCollectionCounter = 0
      snapCollectionCounter = 0
      response = `python "#{$pythonFilePath}" #{@transport.host} #{@transport.user} #{@transport.password} volumecollectioninfoshow`
      response.split("\n").each do |line|
        if (counter < 2)
          counter = counter + 1
          next
        end
        if (line.to_s.strip.length > 0 && line =~ /^\S+/ )
          volumeCollectionCounter = volumeCollectionCounter + 1
        end
      end
      counter = 0
      response = `python "#{$pythonFilePath}" #{@transport.host} #{@transport.user} #{@transport.password} snapcollectioninfoshow`
      response.split("\n").each do |line|
        if (counter < 2)
          counter = counter + 1
          next
        end
        if (line.to_s.strip.length > 0 && line =~ /^\S+/ )
          snapCollectionCounter = snapCollectionCounter + 1
        end
      end
      @collectionMap['Volume Collections'] = "#{volumeCollectionCounter}"
      @collectionMap['Custom Snapshot Collections'] = "#{snapCollectionCounter}"
      @collectionMap['Snapshot Collections'] = "#{@facts['Snapshots']}"
      JSON.pretty_generate(@collectionMap)
    end

    def getmembercountinfo
      memberCounter = 0
      resp = `"#{$memberFilePath}" show`
      if (resp.match("% Error"))
        raise Puppet::Error, "Failed to fetch the equallogic pools: #{resp}"
      end
      resp.split("\n").each do |line|
        member = line.to_s.strip
        if ( member.size > 0 )
          memberCounter = memberCounter + 1
        end
      end
      memberCounter
    end

    def getvolumelist
      counter = 0
      volumeList = Array.new
      resp = `"#{$volumeFilePath}" show`
      resp.split("\n").each do |line|
        if (counter < 3)
          counter = counter + 1
          next
        else
          volumeName = line.split(' ').first.to_s.strip
          response = `python "#{$pythonFilePath}" #{@transport.host} #{@transport.user} #{@transport.password} volumeshow "#{volumeName}"`
          if (response.match("% Error"))
            next
          end
          volumeList.push(volumeName)
        end
      end
      volumeList
    end

    def getstoragepoolinfo
      @poolPropertiesMap = {}
      @poolMap = {}
      resp = `"#{$poolFilePath}" show`
      if (resp.match("% Error"))
        raise Puppet::Error, "Failed to fetch the equallogic pools: #{resp}"
      end
      counter = 0
      resp.split("\n").each do |line|
        if (counter < 3)
          counter = counter + 1
          next
        else
          res = line.split(' ')
          memberName = res[0].to_s.strip
          @poolPropertiesMap["Members"] = res[2].to_s.strip
          @poolPropertiesMap["Total"] = res[4].to_s.strip
          @poolMap["#{memberName}"] = @poolPropertiesMap
        end
      end
      JSON.pretty_generate(@poolMap)
    end

    def getgeneralsettinginfo
      @generalMap = {}
      @groupPropertiesMap = {}
      response = `python "#{$pythonFilePath}" #{@transport.host} #{@transport.user} #{@transport.password} discoverygrpparamsshow`
      if (response.match("% Error"))
        raise Puppet::Error, "Failed to fetch the equallogic group parameters: #{response}"
      end
      response.split("\n").each do |line|
        res = line.split(":")
        name = res[0].to_s.strip
        value = res[1].to_s.strip
        if name == "Name"
          @generalMap['Group Name'] = value
          @facts['Group Name'] = value
        elsif name == "Group-Ipaddress"
          @generalMap['IP Address'] = value
        elsif name == "Management-Ipaddress"
          @facts['Management IP'] = value
        elsif name == "Location"
          @generalMap['Location'] = value
        end
      end
      JSON.pretty_generate(@generalMap)
    end
  end
end