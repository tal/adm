require 'yaml'
require 'typhoeus'
require 'multi_json'
require "adm/version"
require "adm/access_token"
require "adm/message"
require "adm/notification"

module ADM
  extend self
  attr_writer :message_url, :client_id, :client_secret

  def config
    if File.exists?('./config/adm.yml')
      YAML.load_file('./config/adm.yml')
    else
      {}
    end
  end

  def client_id
    @client_id ||= config['client_id']
  end

  def client_secret
    @client_secret ||= config['client_secret']
  end
end
