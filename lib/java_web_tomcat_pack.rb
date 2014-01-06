#! /usr/bin/ruby -w
# coding: utf-8
# author: Ulric Qin
# mail: qinxiaohui@xiaomi.com

require 'java_pack'
require 'system_util'
require 'fetcher'

class JavaWebTomcatPack < JavaPack

  def initialize(global)
    super(global)
  end

  def compile
    Fetcher.install_jdk(global)
    #Fetcher.install_tomcat(global)
    #copy_webapp_to_tomcat
    #move_tomcat_to_root
    #copy_resources
    setup_profiled
  end

  def java_opts
    # Don't override Tomcat's temp dir setting
    opts = super.merge({ '-Dhttp.port=' => '$PORT' })
    opts.delete('-Djava.io.tmpdir=')
    opts
  end

end