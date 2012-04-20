#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2012, Coroutine LLC
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
#

include_recipe "java::default"

# Set up Config and install directories
[node['elasticsearch']['config_dir'], 
 node['elasticsearch']['install_dir'],
 node['elasticsearch']['data_dir'],
 node['elasticsearch']['log_dir']].each do |dir|
  directory dir do
    owner         "root"
    group         "root"
    mode          0755
    action        :create
    recursive     true
  end
end

remote_file "/tmp/elasticsearch-#{node[:elasticsearch][:version]}.tar.gz" do
  source    "http://cloud.github.com/downloads/elasticsearch/elasticsearch/elasticsearch-#{node['elasticsearch']['version']}.tar.gz"
  mode      "0644"
  checksum  node[:elasticsearch][:checksum]
end

bash "gunzip elasticsearch" do
  user  "root"
  cwd   "/tmp"
  code  %(gunzip elasticsearch-#{node[:elasticsearch][:version]}.tar.gz)
  not_if{ File.exists? "/tmp/elasticsearch-#{node[:elasticsearch][:version]}.tar" }
end

bash "extract elasticsearch" do
  user  "root"
  cwd   node['elasticsearch']['install_dir']
  code  <<-EOH
  tar -xf /tmp/elasticsearch-#{node[:elasticsearch][:version]}.tar && \
  mv elasticsearch-#{node[:elasticsearch][:version]}/* . && \
  rmdir elasticsearch-#{node[:elasticsearch][:version]}
  EOH
  not_if{ File.exists? "#{node[:elasticsearch][:install_dir]}/bin/elasticsearch" }
end

# Write config files
template "#{node['elasticsearch']['config_dir']}/elasticsearch.yml" do
  source  "elasticsearch.yml.erb"
  owner   "root"
  group   "root"
  action  :create
end
template "#{node['elasticsearch']['config_dir']}/logging.yml" do
  source  "logging.yml.erb"
  owner   "root"
  group   "root"
  action  :create
end

# Now, configure supervisord to run elasticsearch with something like:
#
#   [program:logstash_elasticsearch]
#   directory=/opt/elasticsearch
#   command=/opt/elasticsearch/bin/elasticsearch -f
#   environment=ES_MAX_MEM=1G, ES_MIN_MEM=256M
#
