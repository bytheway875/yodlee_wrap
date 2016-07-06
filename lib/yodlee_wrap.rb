require 'rubygems'
require 'logger'
require 'faraday'
require 'socksify'
require 'socksify/http'

require File.dirname(__FILE__) + "/yodlee_wrap/version"
require File.dirname(__FILE__) + "/yodlee_wrap/config"
require File.dirname(__FILE__) + "/yodlee_wrap/response"
require File.dirname(__FILE__) + "/yodlee_wrap/yodlee_api"

class Faraday::Adapter::NetHttp
  def net_http_connection(env)
    if !(proxy = env[:request][:proxy]).empty?
      if proxy[:socks]
        # TCPSocket.socks_username = proxy[:user] if proxy[:user]
        # TCPSocket.socks_password = proxy[:password] if proxy[:password]
        Net::HTTP::SOCKSProxy(proxy[:uri].host, proxy[:uri].port)
      else
        Net::HTTP::Proxy(proxy[:uri].host, proxy[:uri].port, proxy[:uri].user, proxy[:uri].password)
      end
    else
      Net::HTTP
    end.new(env[:url].host, env[:url].port)
  end
end
