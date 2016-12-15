# replace "enterprise" for Enterprise Edition
default['mongodb']['edition'] = 'community'
default['mongodb']['version'] = '3.4'

default['mongodb']['config_file'] = '/etc/mongod.conf'
default['mongodb']['data_path'] = '/var/lib/mongo'
default['mongodb']['pid']['path'] = '/var/run/mongodb'
default['mongodb']['pid'] = '/var/run/mongodb/mongod.pid'
default['mongodb']['log_path'] = '/var/log/mongodb/mongod.log'
default['mongodb']['port'] = '27017'