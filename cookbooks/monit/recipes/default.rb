#
# Cookbook Name:: fast_start
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install sendmail so that monit can send us alert emails
package "sendmail" do
  action :install
end

remote_file "/tmp/monit.tar.gz" do
  source "http://mmonit.com/monit/dist/binary/5.4/monit-5.4-linux-x64.tar.gz"
  notifies :run, "bash[install_monit]", :immediately
  not_if {::File.exists?("/var/run/monit-5.4")}
end

bash "install_monit" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar -zxf monit.tar.gz
    cp -r monit-5.4 /var/run/
  EOH
  not_if {::File.exists?("/var/run/monit-5.4")}
end

directory "/etc/monit.d" do
  owner "root"
  group "root"
  mode 0700
  recursive true
  action :create
end

directory "/var/monit" do
  owner "root"
  group "root"
  mode 0700
  recursive true
  action :create
end

if !node[:monit].nil? && !node[:monit][:services].nil? 
  # build monit config files
  node[:monit][:services].each do |service| #=> returns an array of services that should be configured
    template "/etc/monit.d/#{service}_conf" do
      owner "root"
      group "root"
      mode 0700
      source "monitrc_#{service}_conf.erb"
    end
  end
end

if !node[:monit].nil? && !node[:monit][:workers].nil?
  #create worker config file
  template "/etc/monit.d/workers_conf" do
    owner "root"
    group "root"
    mode 0700
    source "monitrc_worker_conf.erb"
  end
end

template "/etc/monit.d/check_disk_conf" do
  owner "root"
  group "root"
  mode 0700
  source "check_disk_conf.erb"
end

template "/etc/monitrc" do
  owner "root"
  group "root"
  mode 0700
  source 'monitrc.erb'
end

service "monit" do
  action [:start]
  start_command "/var/run/monit-5.4/bin/monit"
end

