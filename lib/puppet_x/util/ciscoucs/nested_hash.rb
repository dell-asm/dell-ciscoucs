
module PuppetX
  module Util
    module Ciscoucs
  class NestedHash < Hash
  def initialize
    super do |hash, key|
    hash[key] = NestedHash.new
    end
  end
  end
end
  end
end
