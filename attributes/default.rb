
default['masala_elasticsearch']['cluster_name'] = 'no_name'

default['masala_elasticsearch']['version'] = '5.6.3'
default['masala_elasticsearch']['config']['node.master'] = true
default['masala_elasticsearch']['config']['node.data'] = true
default['masala_elasticsearch']['config']['cluster.routing.allocation.awareness.attributes'] = 'rack_id,zone_id'
default['masala_elasticsearch']['config']['node.attr.rack_id'] = 'default_rack'
default['masala_elasticsearch']['config']['node.attr.zone_id'] = 'default_zone'
default['masala_elasticsearch']['config']['path.data'] = '/elasticsearch/data'
default['masala_elasticsearch']['config']['path.logs'] = '/elasticsearch/logs'
default['masala_elasticsearch']['config']['discovery.zen.minimum_master_nodes'] = '2'

default['sysctl']['params']['vm']['max_map_count'] = "262144"
