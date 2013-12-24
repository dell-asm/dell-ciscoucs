
class Puppet_X::Util::Ciscoucs::NestedHash < Hash
  def initialize
    super do |hash, key|
    hash[key] = NestedHash.new
    end
  end
end

