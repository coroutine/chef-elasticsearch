#
# Cookbook Name:: elasticsearch
# Attributes:: default 
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

default[:elasticsearch][:version]     = "0.18.7"
default[:elasticsearch][:checksum]    = '654642232077ef8decb64b553bf3216c8c9f2bdd157bc837667bc6120900e10f'

default[:elasticsearch][:config_dir]  = "/etc/elasticsearch"
default[:elasticsearch][:install_dir] = "/opt/elasticsearch"
default[:elasticsearch][:data_dir]    = "/opt/elasticsearch/data"
default[:elasticsearch][:log_dir]     = "/var/log/elasticsearch"

default[:elasticsearch][:http][:enabled]  = true
default[:elasticsearch][:http][:port]     = 9200
default[:elasticsearch][:http][:max_content_length] = "100mb"

default[:elasticsearch][:bootstrap][:mlockall] = true

default[:elasticsearch][:index][:number_of_shards] = 1   # Development values
default[:elasticsearch][:index][:number_of_replicas] = 0

default[:elasticsearch][:cluster_name]= "default"
default[:elasticsearch][:log_level]   = "DEBUG"
