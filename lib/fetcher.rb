require 'net/http'
require 'uri'
require 'yaml'
require 'fileutils'
require 'system_util'

class Fetcher

  def self.install_jdk(global)
    puts 'Installing JDK...'
    tmp_jdk = fetch(global.tmp_jdk_path, global.remote_jdk_url)

    dir = File.dirname(global.target_jdk_tarball)
    FileUtils.mkdir_p(dir)
    FileUtils.mv(tmp_jdk, global.target_jdk_tarball)

    puts "Unpacking JDK to #{global.jdk_dir}..."
    tar_output = SystemUtil.run_with_err_output "tar pxzf #{global.target_jdk_tarball} -C #{global.jdk_dir}"

    FileUtils.rm_rf global.target_jdk_tarball

    unless File.exists?("#{global.jdk_dir}/bin/java")
      puts 'Unable to retrieve the JDK'
      puts tar_output
      exit 1
    end
  end

  def self.fetch(file_path, url)
    puts "Downloading #{file_path} from #{url} ... "

    dir = File.dirname(file_path)
    FileUtils.mkdir_p(dir)
    File.open(file_path, 'w') do |tf|
      begin
        Net::HTTP.get_response(URI.parse(url)) do |response|
          unless response.is_a?(Net::HTTPSuccess)
            puts 'Could not fetch file (%s): %s/%s' % [file_path, response.code, response.body]
            return
          end

          response.read_body do |segment|
            tf.write(segment)
          end
        end
      ensure
        tf.close
      end
    end
    file_path
  end

end