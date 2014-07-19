name             "hipsnip-jetty"
maintainer       "HipSnip Limited"
maintainer_email "adam@hipsnip.com/remy@hipsnip.com"
license          "Apache 2.0"
description      "Installs/Configures Jetty"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'), :encoding => 'utf-8')
version          "0.9.1"

supports 'ubuntu', ">= 12.04"
%w{ centos redhat fedora }.each do |os|
  supports os
end

depends "java", ">= 1.10.0"
