#
# Cookbook Name:: mmonit
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


remote_file "/tmp/mmonit.tar.gz" do
  source "http://mmonit.com/dist/mmonit-2.4-linux-x64.tar.gz"
  notifies :run, "bash[install_mmonit]", :immediately
  not_if {::File.exists?("/var/run/mmonit-2.4")}
end

bash "install_mmonit" do
  not_if "/var/run/monit-2.4"
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar -zxf mmonit.tar.gz
    cp -r mmonit-2.4 /var/run/
  EOH
  not_if {::File.exists?("/var/run/mmonit-2.4")}
end

service "mmonit" do
  action :start
  enabled true
  start_command "/var/run/mmonit-2.4/bin/mmonit"
end