module PuppetX
  module Puppetlabs
    module Transportciscoucs
      # Accepts a puppet resource reference, resource catalog, and loads connectivity info.
      def self.retrieve(options={})
        unless res_hash = options[:resource_hash]
          catalog = options[:catalog]
          res_ref = options[:resource_ref].to_s
          name = Puppet::Resource.new(nil, res_ref).title
          res_hash = catalog.resource(res_ref).to_hash
          doconnect(res_hash)
        end

      end

      def self.doconnect(res_hash)
        transport = PuppetX::Puppetlabs::Transportciscoucs::Ciscoucs.new(res_hash)
        transport.connect
        transport
      end
    end
  end
end
