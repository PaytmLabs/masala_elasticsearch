#
# Cookbook Name:: masala_elasticsearch
# Recipe:: default
#
# Copyright 2016, Paytm Labs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'masala_base::default'

primary_if = node['network']['interfaces'][node['system']['primary_interface']]
primary_addrs = primary_if['addresses']
primary_addrs_ipv4 = primary_addrs.select { |_addr, attrs| attrs['family'] == 'inet' }
primary_ip = primary_addrs_ipv4.keys.first

elasticsearch_user 'elasticsearch' do
  username 'elasticsearch'
  groupname 'elasticsearch'
  shell '/bin/bash'
  comment 'Elasticsearch User'
end

elasticsearch_install 'elasticsearch' do
  type 'tarball'
  version node['masala_elasticsearch']['version']
  dir '/opt'
end

elasticsearch_configure 'elasticsearch' do
  action :manage
  configuration node['masala_elasticsearch']['config'].deep_merge({
    'node.name' => node['system']['short_hostname'],
    'cluster.name' => node['masala_elasticsearch']['cluster_name'],
    'network.bind_host' => primary_ip,
    'network.publish_host' => primary_ip
  })
  path_home    '/opt/elasticsearch'
  path_conf    '/opt/elasticsearch/etc'
  path_pid     '/opt/elasticsearch/var/run'
  path_bin     '/opt/elasticsearch/bin'
  path_plugins '/opt/elasticsearch/plugins'
  path_data    node['masala_elasticsearch']['config']['path.data']
  path_logs    node['masala_elasticsearch']['config']['path.logs']
end

elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end

if node['masala_base']['dd_enable'] and not node['masala_base']['dd_api_key'].nil?
  node.set['datadog']['elasticsearch']['instances'] = [
      {
          :url => "http://#{primary_ip}:9200",
          :pshard_stats => true,
          :shard_level_metrics => true
      }
  ]
  include_recipe 'datadog::elasticsearch'
end

