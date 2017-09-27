require 'facter'
require 'puppet'

def zookeeper_myid
  ip_address = Facter.value(:networking)['ip']
  ip_address.split('.').reduce(0) do |t, v|
    (t << 8) + v.to_i
  end
end

Facter.add(:zookeeperd, type: :aggregate) do
  chunk(:myid) do
    res = {}
    res['myid'] = zookeeper_myid
    res
  end
end
